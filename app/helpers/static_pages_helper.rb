module StaticPagesHelper

# Returns an appropriate dynamic title for static pages
def full_title (page_title)
	base_title = "Tapsell"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

end
