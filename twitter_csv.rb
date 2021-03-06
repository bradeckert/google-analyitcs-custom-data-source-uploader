require 'csv'
require './client'

#  Takes a CSV file of ad data from twitter 
#  and converts it for google analytics 
#
#  Output: CSV ready to be uploaded to GA
$order_out = ['ga:source', 'ga:medium', 'ga:campaign', 'ga:adCost', 'ga:adClicks', 'ga:impressions']
def convert(twitter_in_file_path)
	out = $order_out.to_csv
	t = Time.now
	t = t.strftime "%Y-%m-#{t.day-1}"
	CSV.foreach(twitter_in_file_path, :headers => true) do |row|
		if row['time'].include? t
			out_temp = ['twitter.com', row['product type'], row['campaign'], row['Spend'].to_f.round(2), row['Clicks'], row['Impressions']]
			out += out_temp.to_csv
		end
	end
	File.open("out_" + twitter_in_file_path, "wb") { |file| file.write(out) }	
	puts "Converted"
	File.delete(twitter_in_file_path)
	return "out_" + twitter_in_file_path
end

def convert_and_upload(twitter_in_file_path)
	twitter_out_file_path = convert(twitter_in_file_path)
	upload('twitter', twitter_out_file_path)
end


if __FILE__ == $0
	twitter_out_file_path = convert(ARGV[0])
	upload('twitter', twitter_out_file_path)
end
