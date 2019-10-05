# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'net/http'
require 'json'
require 'active_support/all'
require 'google/apis/youtube_v3'

PER_PAGE_TAGS = 100 # max 100
GET_TAGS_URI = 'https://qiita.com/api/v2/tags'
MINIMUM_TAGS_USED_COUNT = 300
GET_VIDEOS_SEARCH_URI = 'https://www.googleapis.com/youtube/v3/search'
PER_PAGE_VIDEOS_SEARCH = 50 # max 50
MAX_SEARCH_VIDEOS_COUNT = 50
GET_VIDEOS_DETAIL_URI = 'https://www.googleapis.com/youtube/v3/videos'

# ///// yotubeのカテゴリID /////
module Category
    FILM_AND_ANIMATION = 1
    AUTOS_AND_VEHICLES = 2
    MUSIC = 10
    PETS_AND_ANIMALS = 15
    SPORTS = 17
    TRAVEL_AND_EVENTS = 19
    GAMING = 20
    PEOPLE_AND_BLOGS = 22
    COMEDY = 23
    ENTERTAINMENT = 24
    NEWS_AND_POLITICS = 25
    HOWTO_AND_STYLE = 26
    EDUCATION = 27
    SCIENCE_AND_TECHNOLOGY = 28
end

# ///// タグデータ取得用メソッド /////
def GetTags(sort='id', page=1)
    # リクエスト情報を作成
    uri = URI.parse (GET_TAGS_URI)
    uri.query = URI.encode_www_form({ sort: sort, per_page: PER_PAGE_TAGS, page: page })
    req = Net::HTTP::Get.new(uri.request_uri)

    # リクエスト送信
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(req)

    # 次ページを計算 (API仕様 上限は100ページ)
    total_page = ((res['total-count'].to_i - 1) / PER_PAGE_TAGS) + 1
    total_page = (total_page > 100) ? 100 : total_page
    next_page = (page < total_page) ? page + 1 : nil

    # 返却 [HTTPステータスコード, 次ページ, タグ情報の配列]
    return res.code.to_i, next_page, JSON.parse(res.body)
end

# ///// 動画データ検索用メソッド /////
def SearchVideosList(query, max_results=50, order='viewCount', type='video', video_category_id, next_page_token)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['GOOGLE_API_KEY']

    # リクエスト情報
    opt = {
        q: query,
        max_results: max_results,
        order: order,
        type: type
    }
    unless video_category_id.blank?
        opt[:video_category_id] = video_category_id
    end
    unless next_page_token.blank?
        opt[:page_token] = next_page_token
    end

    # リクエストを送信
    results = service.list_searches(:id, opt)

    # ページ数を計算
    total_page = ((results.page_info.total_results.to_i - 1) / PER_PAGE_VIDEOS_SEARCH) + 1
    next_page_token = results.next_page_token

    # 返却 [次ページを表示するためのトークン, 取得全ページ数, 動画検索結果の配列]
    return next_page_token, total_page, results
end

# ///// 動画詳細データ取得用メソッド /////
def GetVideosDetail(id)
    # リクエスト情報を作成
    uri = URI.parse (GET_VIDEOS_DETAIL_URI)
    uri.query = URI.encode_www_form({
                    key: ENV['GOOGLE_API_KEY'],
                    id: id,
                    part: 'snippet,statistics',
                    fields: 'items(id,snippet(title,description,thumbnails),statistics(viewCount,likeCount,dislikeCount,favoriteCount))'
                })
    req = Net::HTTP::Get.new(uri.request_uri)

     # リクエスト送信
     http = Net::HTTP.new(uri.host, uri.port)
     http.use_ssl = true
     res = http.request(req)

    # 返却 [HTTPステータスコード, 動画詳細情報の配列]
    return res.code.to_i, JSON.parse(res.body)
end

# ///// タグデータの登録 /////
sort = 'count'
next_page = 1
items_count = 0

status, next_page, tags = GetTags(sort, next_page)
while status == 200
    tags.each {|tag|
        items_count = tag['items_count']
        break if items_count < MINIMUM_TAGS_USED_COUNT
        # 重複が無ければタグデータを登録する
        Tag.where(tag: tag['id']).first_or_create do |t|
            t.active_flag = true
        end
    }
    break if items_count < MINIMUM_TAGS_USED_COUNT
    status, next_page, tags = GetTags(sort, next_page)
end

# ///// 動画データの検索と登録 /////
order = 'viewCount'
type = 'video'
next_page_token = nil
page = 1

# タグの一覧を取得して、タグをキーワードに動画検索
# ToDo: レコード数の制限から取得レコード数をidで制限している
# ToDo: youtuvbe api の使用制限から取得範囲をどうするか考慮する必要あり
Tag.where("id<=2 AND active_flag=true").find_each do |tag|
    next_page_token, total_page, result_search = SearchVideosList(tag.tag, PER_PAGE_VIDEOS_SEARCH, order, type, Category::EDUCATION, next_page_token)
    while page <= total_page do
        result_search.items.each do |item|
            id = item.id
            # 重複が無ければvideo_idとtag_idを登録する
            Video.where(video_id: id.video_id).first_or_create do |t|
                t.tag_id = tag.id
                t.active_flag = true
            end
        end

        page += 1
        break if PER_PAGE_VIDEOS_SEARCH * page < MAX_SEARCH_VIDEOS_COUNT
        next_page_token, total_page, result_search = SearchVideosList(tag, PER_PAGE_VIDEOS_SEARCH, order, type, Category::EDUCATION, next_page_token)
    end
end

# video_idから動画の詳細を取得して登録する
# ToDo: youtuvbe api の使用制限から取得範囲をどうするか考慮する必要あり
Video.where('tag_id<=2 AND title is null').find_each do |video|
    status, result_search = GetVideosDetail(video.video_id)
    next unless status == 200

    snippet = result_search['items'][0]['snippet']
    statistics = result_search['items'][0]['statistics']

    # 動画詳細を登録する
    video.title = snippet['title']
    video.description = snippet['description']
    video.thumbnail_url = snippet['thumbnails']['default']['url']
    video.view_count = statistics['viewCount'].to_i
    video.like_count = statistics['likeCount'].to_i
    video.dislike_count = statistics['dislikeCount'].to_i
    video.favorite_count = statistics['favoriteCount'].to_i
    video.save
end
