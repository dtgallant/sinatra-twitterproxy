  function build_api_url() {
      var count = (s.fetch === null) ? s.count : s.fetch;
      var common_params = '&include_entities=1&callback=?';
      if (s.list) {
        return s.twitter_api_proxy_url + "/1.1/lists/statuses.json?slug=" + s.list + "&owner_screen_name=" + s.username + "&page=" + s.page + "&per_page=" + count + common_params;
      } else if (s.favorites) {
        return s.twitter_api_proxy_url+"/1.1/favorites/list.json?screen_name="+s.username[0]+"&page="+s.page+"&count="+count+common_params;
      } else if (s.query === null && s.username.length === 1) {
        return s.twitter_api_proxy_url+'/1.1/statuses/user_timeline.json?screen_name='+s.username[0]+'&count='+count+(s.retweets ? '&include_rts=1' : '')+'&page='+s.page+common_params;
      } else {
        var query = (s.query || 'from:'+s.username.join(' OR from:'));
        return s.twitter_api_proxy_url + '/1.1/search/tweets.json?q=' + encodeURIComponent(query) + common_params;
      }
    }



  function load(widget) {
      var loading = $('<p class="loading">'+s.loading_text+'</p>');
      if (s.loading_text) $(widget).not(":has(.tweet_list)").empty().append(loading);
      $.getJSON(build_api_url(), function(data){
        var tweets = $.map(data.statuses || data, extract_template_data);
        tweets = $.grep(tweets, s.filter).sort(s.comparator).slice(0, s.count);
        $(widget).trigger("tweet:retrieved", [tweets]);
      });
    }


Request URL:localhost:3000/1.1/statuses/user_timeline.json?screen_name=AVMAmeets&count=25&include_rts=1&page=1&include_entities=1&callback=jQuery164044537529442459345_1378051426483&_=1378051426497
Request Headersview source
Accept:*/*
Cache-Control:no-cache
Pragma:no-cache
Referer:http://localhost/twitter-proxy/demo-site/
User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.62 Safari/537.36
Query String Parametersview sourceview URL encoded
screen_name:AVMAmeets
count:25
include_rts:1
page:1
include_entities:1
callback:jQuery164044537529442459345_1378051426483
_:1378051426497


    