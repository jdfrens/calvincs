@schema_date = "2005"

atom_feed(:schema_date => @schema_date) do |feed|
  feed.title("Calvin College Computer Science - News and Events")
  feed.updated(@updated_at)

  render :partial => "todays_event.atom", :collection => @todays_events, :locals => { :feed => feed }
  render :partial => "newsitem.atom", :collection => @newsitems, :locals => { :feed => feed }

end
