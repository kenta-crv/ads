module ApplicationHelper
  def default_meta_tags
    {
      site: "恵比寿の高級マンション民泊貸出",
      title:"<%= 恵比寿の高級マンション民泊貸出%>",
      description: "恵比寿駅徒歩8分の好立地マンションの民泊サイトです。",
      canonical: request.original_url,  # 優先されるurl
      charset: "UTF-8",
      reverse: true,
      separator: '|',
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('favicon.ico'),  rel: 'apple-touch-icon' },
      ],
	    canonical: request.original_url  # 優先されるurl

    }
  end

end
