module PageHelper
	def page_published_public?(page)
		page.published? && page.is_public?
	end

	def page_published_va_only?(page)
		page.is_public? == false && page.published?
	end
end
