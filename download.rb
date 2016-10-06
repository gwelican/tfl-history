# Encoding: utf-8
#
#!/usr/bin/ruby

require "mechanize"
require 'active_support/all'

@agent = Mechanize.new
@agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

fmt = "%d/%m/%Y"

start_time = Date.today
end_time = start_time - 8.weeks


def login(username, password)
  page = @agent.get("https://oyster.tfl.gov.uk/oyster/entry.do")
  form = page.form_with(:id => "sign-in")
  form.UserName = username
  form.Password = password
  return form.submit
end

def selectCard(page, number)
  f = page.form_with(:name => "selectCardForm")
  f.cardId = number
  return f.submit
end

def viewHistory(page, from, to)
  page = page.links_with(:text => "View journey history").first.click
  form = page.form_with(:name => "dateRangeForm")
  form.dateRange = "custom date range"
  form.csDateFrom = from
  form.csDateTo = to

  return form.submit

end

def downloadHistory(page)
  form = page.form_with(:name => "jhDownloadForm")
  form.submit.save_as "extract_#{Date.today.strftime('%Y-%m-%d_%H%M%S')}.csv"
end

from = start_time.strftime(fmt)
to = end_time.strftime(fmt)


cnf = YAML::load(File.open('config.yaml'))

page = login(cnf['username'], cnf['password'])
page = selectCard(page, "060365470360")
page = viewHistory(page, from, to)
page = downloadHistory(page)
