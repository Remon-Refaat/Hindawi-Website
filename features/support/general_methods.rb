def new_submission(type, section)
  @article = type
  step %Q{Navigate to "http://beta.mts.hindawi.com/remon.refaat@hindawi.com/123456"}
  step %Q{Click on "Submit a Manuscript"}
  if section == "regular section"
    find("//a[normalize-space()='#{@journal_name}']").click
    page_title = find('//*[@id="container"]/div[5]/h1').text
    check_for_manuscript_page_title(page_title)
    else
    x = select_from_dbs("SELECT top 1 JournalSubCode,
            COUNT(DISTINCT IssueId) [Issues Count]
FROM    dbo.Journals WITH ( NOLOCK )
      JOIN dbo.Issues WITH ( NOLOCK ) ON Issues.JournalId = Journals.JournalId
WHERE   IsCeased = 0
      AND IsSold = 0
      AND InTestMode = 0
      AND JournalOwner = 1
      AND IsClosed = 0
      AND IsCanceled = 0
      AND IsArchived = 0
      AND CONVERT(DATE, MSDueDate) >= CONVERT(DATE, GETDATE())
GROUP BY JournalSubCode")
    x.each do |row|
      @journal_id = row["JournalSubCode"]
    end
    step %Q{Navigate to "http://beta.mts.hindawi.com/submit/journals/#{@journal_id}/"}
    find("//*[@id='container']/div[5]/ul[2]/li[1]/a").click
  end
  step %Q{Choose 1 authors}
  step %Q{Add the data of all authors}, table(%q{| First Name | Last Name | Email Address| Affiliation| Country | Corresponding Author |
      | Remon| Refaat| remon.refaat@hindawi.com | Cairo University | Egypt| Yes|})
  step %Q{Add title of the manuscript}
  page.find("//*[@id='Manuscript_TypeId']/option[normalize-space()='#{type}']").click
  step %Q{Choose a file "test1.docx" for "ManuscriptFile"}
  step %Q{Select the answers of the questions "No", "Yes", and "Yes"}
  step %Q{Press on "Submit"}
end


