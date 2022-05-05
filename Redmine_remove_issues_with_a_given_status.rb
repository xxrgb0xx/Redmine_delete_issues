require 'rest-client'

REDMINE_ADDR = 'http://localhost'
REDMINE_TOKEN = ''
REDMINE_STATUS_ID = '13' ### Issues with this status ID will be removed!
#REDMINE_LOGIN = ''
#REDMINE_PASS = ''
#get_info = RestClient.get "http://#{REDMINE_LOGIN}:#{REDMINE_PASS}@#{REDMINE_ADDR[/(?<=http:\/\/).*/]}/issues"

get_info = RestClient.get "#{REDMINE_ADDR}/issues.xml?key=#{REDMINE_TOKEN}&status_id=#{REDMINE_STATUS_ID}&limit=1" ### Get 1st issue with assigned status id
issues_total = get_info[/(?<=<issues total_count=").*(?=" offset=)/].to_i ### Get total number of issues with assigned status id
issues_counter = 0
issues_ar = []
while issues_counter < issues_total ### Fill the array of issues
    request = RestClient.get "#{REDMINE_ADDR}/issues.xml?key=#{REDMINE_TOKEN}&status_id=#{REDMINE_STATUS_ID}&limit=1&offset=#{issues_counter}"
    issues_ar << request
    issues_counter += 1
end
issues_ids_ar = []
issues_ar.each do |current_issue| ### Fill the array of issues ids
    issues_ids_ar << current_issue[/(?<=<issue><id>).*(?=<\/id>)/]
end
issues_ids_ar.each do |current_id| ### Deleting issues
    begin
        RestClient.delete "#{REDMINE_ADDR}/issues.xml?key=#{REDMINE_TOKEN}&id=#{current_id}"
        rescue RestClient::NotFound => error
        puts error
    end
end 
