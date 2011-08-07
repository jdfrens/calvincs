Factory.define :conference, :class => Event do |conference|
  conference.event_kind "Conference"
  conference.title "The Conference"
  conference.start Chronic.parse("tomorrow")
  conference.stop Chronic.parse("two days from now")
  conference.description "Description of the conference."
end

Factory.define :colloquium, :class => Event do |colloquium|
  colloquium.event_kind "Colloquium"
  colloquium.title "The Conference"
  colloquium.start Chronic.parse("tomorrow at 3:30pm")
  colloquium.stop Chronic.parse("tomorrow at 4:30pm")
  colloquium.description "Description of the colloquium"
end
