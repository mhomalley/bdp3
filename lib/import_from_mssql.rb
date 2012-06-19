#!/usr/bin/env ruby
$KCODE='utf-8'
require 'odbc'

class ImportFromMSSQL
  def initialize
    @mssql = ODBC.connect('DailyPlanetSQL', 'dpSQL', 'al5600')
  end

  def datefield_to_date(datefield)
    if datefield == '02-29-01'
      datefield = '02-28-01'
    end
    month, day, year = datefield.split('-')
    Date.new(2000 + year.to_i, month.to_i, day.to_i)
  end

  def import
    query_string = <<-EOS
      SELECT
        ID,
        headline,
        datefield,
        priority,
        copy,
        photofile,
        section,
        author,
        subtitle,
        datestring
      FROM
        Articles
      WHERE
        copy NOT LIKE ''
      ORDER BY
        ID
    EOS
    result = query(query_string)
    $stdout.write("Articles:\n")
    last_id = nil
    begin
      for row in result
        begin
          $stdout.write(".")
          $stdout.flush
          last_id = row[0]
          article = Article.find(:first, :conditions => ['id = ?', row[0]])
          if article != nil
            next
          end
          date = datefield_to_date(row[2])
          issue = Issue.find_or_create_by_date(date)
          image = nil
          if row[5] != nil
            image = Image.find_by_file_name(row[5])
            if image == nil
              image = Image.new
              image.file_name = row[5]
            else
              if image.issue.id != issue.id
                image = Image.new
                image.file_name = row[5]
              end
            end  
          end
          article = Article.find_by_id(row[0])
          if article == nil
            article = Article.new
            article.id = row[0]
          end
          if image != nil
            article.images << image
          end
          article.issue = issue
          article.headline = row[1]
          article.priority = row[3]
          article.copy = row[4]
          article.section = row[6]
          article.author = row[7]
          article.save!
        rescue
          $stderr.write("\n")
          $stderr.write("Error #{$!}\n")
          $stderr.write("Error on row: #{row.inspect}\n")
          $stderr.flush
        end
      end
    rescue
      $stderr.write("\n")
      $stderr.write("Error #{$!}\n")
      $stderr.write("Error: #{last_id}\n")
      $stderr.write("Error on row: #{row.inspect}\n")
      $stderr.flush
    end
    result.drop
    $stdout.write("\n")
    $stdout.write("Images\n")
    query_string = <<-EOS
      SELECT
        ID,
        photofile,
        caption,
        imagedate
      FROM
        FrontPageImage
    EOS
    result = query(query_string)
    for row in result
      begin
	$stdout.write(".")
	$stdout.flush
	date = datefield_to_date(row[3])
	issue = Issue.find_or_create_by_date(date)
	image = Image.find_or_create_by_file_name(row[1])
	if image.issue != nil and image.issue.id != issue.id
	  image = Image.new
	else
	  if image.caption.nil?
	    image.caption = row[2]
	    image.save!
	  end
	  issue.front_page_image = image
	  issue.save!
	  next
	end
	image.file_name = row[1]
	image.caption = row[2]
	image.save!
	issue.front_page_image = image
	issue.save!
      rescue
        $stdout.write("\n")
        $stdout.write("Error #{$!}\n")
        $stdout.write("Error on row: #{row.inspect}\n")
        $stdout.flush
      end
    end
    result.drop
    $stdout.write("\n")
  end

  def self.run
    importer = ImportFromMSSQL.new
    importer.import
  end

  def query(sql)
    @mssql.run(sql)
  end
end

