# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  remote_id        :string
#  url              :string           not null
#  title            :string
#  thumbnail_url    :string
#  description      :text
#  video_count      :integer
#  subscriber_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  keep_count       :integer          default(8), not null
#  type             :string
#

class NebulaSubscription < Subscription
  def configure_for_me
    Zype.configuration.api_key = Setting.instance.nebula_api_key
  end

  def refresh_metadata
    ias = JSON.parse(
      Nokogiri::HTML(
        RestClient.get('https://watchnebula.com').body
      ).at_css('#initial-app-state').text
    )

    sub_name = url.split('/').last.gsub('/', '')
    nebula_id = ias.dig('channels', 'byURL', sub_name)
    remote_detail = ias.dig('channels', 'byID', nebula_id)
    remote_id = remote_detail.dig('playlist_id')
    z_playlist = Zype::Playlists.new.find(id: remote_id)

    update!(
      remote_id: remote_id,
      title: remote_detail.dig('title'),
      thumbnail_url: remote_detail.dig('avatar'),
      description: remote_detail.dig('bio'),
      video_count: z_playlist.dig('playlist_item_count'),
    ).attributes
  end

  def remote_videos
    []
  end
end
