#!/usr/bin/env ruby

require "mechanize"
require 'active_support/all'

@agent = Mechanize.new
@agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

fmt = "%d/%m/%Y"

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

def downloadHistory(page, path)
  form = page.form_with(:name => "jhDownloadForm")
  form.submit.save_as File.join(path, "extract_#{Date.today.strftime('%Y-%m-%d')}.csv")
end

def readConfig()

  cnf = YAML::load(File.open('config.yaml'))

  path = cnf['location']
  weeks = cnf['weeks']
  unless File.exists?(path)
    abort("The location(#{path}) does not exists.")
  end

  if ! weeks.is_a? Integer or weeks < 0 or weeks > 8 then
    abort("Weeks(#{weeks}) parameter must be an integer between 0 and 8")
  end

  return cnf
end

cnf = readConfig()

start_time = Date.today
end_time = start_time - cnf['weeks'].weeks

from = start_time.strftime(fmt)
to = end_time.strftime(fmt)

page = login(cnf['username'], cnf['password'])
page = selectCard(page, "060365470360")
page = viewHistory(page, from, to)
page = downloadHistory(page, cnf['location'])
