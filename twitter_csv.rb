require 'csv'


#  Takes a CSV file of ad data from twitter 
#  and converts it for google analytics 
#
#  Output: CSV ready to be uploaded to GA
$order_out = ['ga:source', 'ga:medium', 'ga:campaign', 'ga:adCost', 'ga:adClicks', 'ga:impressions']
def convert(twitter_csv_path, twitter_out_file_path)
	out = $order_out.to_csv
	CSV.foreach(twitter_csv_path, :headers => true) do |row|
		out_temp = [row['id'], row['product type'], row['campaign'], row['Spend'], row['Clicks'], row['Impressions']]
		out += out_temp.to_csv
	end
	File.open(twitter_out_file_path, "wb") { |file| file.write(out) }	
end

if __FILE__ == $0
	convert(ARGV[0], ARGV[1])
end