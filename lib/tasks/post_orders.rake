task :post_orders => :environment do
  puts "Fetching Orders...\n"
  Trademe.fetch
end