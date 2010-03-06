Factory.define :conference do |conference|
  conference.title "The Conference"
  conference.start Chronic.parse("tomorrow")
  conference.stop Chronic.parse("two days from now")
end
