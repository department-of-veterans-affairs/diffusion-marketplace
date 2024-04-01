module CommunityHelper
	COMMUNITIES = {
		"va-immersive" => "VA Immersive", 
		"suicide-prevention" => "Suicide Prevention", 
		"age-friendly" => "Age-Friendly"
	}

	def community_slugs
		COMMUNITIES.keys
	end

	def community_names
		COMMUNITIES.values
	end

	def is_community_slug?(str)
		COMMUNITIES.include?(str)
	end

	def community_homepage(slug)
		community_id = PageGroup.where(slug: slug).first&.id
		Page.where(page_group_id: community_id, slug: 'home').first
	end
end