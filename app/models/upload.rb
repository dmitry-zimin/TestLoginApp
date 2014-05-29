class Upload < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  has_attached_file :picture,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    storage: :s3,
    s3_credentials: { bucket: 'login_app' }

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  belongs_to :user

  def to_jq_upload
    {
        'name' => read_attribute(:picture_file_name),
        'size' => read_attribute(:picture_file_size),
        'url' => picture.url(:original),
        'delete_url' => upload_path(self),
        'delete_type' => 'DELETE',
        'thumbnail_url' => picture.url(:thumb)
    }
  end
end
