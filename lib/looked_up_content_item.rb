class LookedUpContentItem
  attr_accessor :path, :document_type

  def initialize(path:, organisations: [], document_type: nil)
    @path = path
    @organisations = organisations
    @document_type = document_type
  end

  def organisations
    @organisations.any? ? @organisations : guess_organisations_for(path)
  end

private

  # ideally we can always find the content item in either the Content Store
  # but in case we can't, determine a sensible default
  def guess_organisations_for(path)
    org_slug = if path =~ %r{^/government/world/organisations}
                 case path
                 when /dfid/ then "department-for-international-development"
                 when /uk-trade-investment/ then "uk-trade-investment"
                 else "foreign-commonwealth-office"
                 end
               else
                 # if we can't determine the org of any content,
                 # the owning organisation defaults to the owners of GOV.UK
                 "government-digital-service"
               end

    org = Organisation.find_by!(slug: org_slug)

    [{
      content_id: org.content_id,
      slug: org.slug,
      web_url: org.web_url,
      title: org.title,
    }]
  end
end
