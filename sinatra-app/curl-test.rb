################################################
# Curl-based testing for AVMA 2013 Attendees API
################################################

#basic settings
#host_url='https://localhost:3001/pushattendees'
#host_url='http://localhost:3001/pushattendeesessions'

host_url='https://avmaproxy.eventkaddy.net/pushattendees'
#host_url='https://avmaproxy.eventkaddy.net/pushattendeesessions'


proxy_key='uniabmxcxgjzfmfxmljhtewzzhiguznyzipomdqauenzbqmnjp'
event_id=18
api_mode='production'
delete_flag='true'


#add/remove attendees
json_data='{"attendees":[{"email":"john3@test.com","first_name":"John3","last_name":"Smith3","registration_id":"5555"},{"email":"bob3@test.com","first_name":"Bob3","last_name":"McDonald3","registration_id":"6666"}]}'

#add/remove attendee sessions
#json_data='{"attendees":[{"email":"john2@test.com","first_name":"John2","last_name":"Smith2","registration_id":"3333","attendee_sessions":["13136","13137","13138","13155"]},{"email":"bob2@test.com","first_name":"Bob2","last_name":"McDonald2","registration_id":"4444","attendee_sessions":["13200","13201","13202"]}]}'



#execute command
cmd = "
/usr/bin/curl -X POST \
-H \"Content-Type: application/json\" \
--data '{\"proxy_key\":\"#{proxy_key}\",\"event_id\":\"#{event_id}\",\"api_mode\": \"#{api_mode}\",\"delete_flag\":\"#{delete_flag}\",\"json_data\":#{json_data}}' \
#{host_url}
" 
puts "CURL CMD #{cmd}" 
curl_result = `#{cmd} 2>&1`  	
puts "\n--------- curl cmd output ---------\n\n #{curl_result} \n------------------- \n"


