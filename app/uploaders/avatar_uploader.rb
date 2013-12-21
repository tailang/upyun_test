# encoding: utf-8
IMAGE_UPLOADER_ALLOW_IMAGE_VERSION_NAMES = %(20x20 30x30 128 1000x1000)
class AvatarUploader < CarrierWave::Uploader::Base
  

  storage :upyun
  #process :get_version_dimensions
  process :time_start

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def default_url
    # 搞一个大一点的默认图片取名 blank.png 用 FTP 传入图片空间，用于作为默认图片
    # 由于有自动的缩略图处理，小图也不成问题
    # Setting.upload_url 这个是你的图片空间 URL
    "#{Setting.upload_url}/blank.png#{version_name}"
  end

   #覆盖 url 方法以适应“图片空间”的缩略图命名
  def url(version_name = "")
    @url ||= super({})
    version_name = version_name.to_s
    return @url if version_name.blank?
    if not version_name.in?(IMAGE_UPLOADER_ALLOW_IMAGE_VERSION_NAMES)
      # 故意在调用了一个没有定义的“缩略图版本名称”的时候抛出异常，以便开发的时候能及时看到调错了
      raise "ImageUploader version_name:#{version_name} not allow."
    end
    [@url,version_name].join("!") # 我这里在图片空间里面选用 ! 作为“间隔标志符”
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
 if super.present?
      @name ||="#{Digest::MD5.hexdigest(original_filename)}.#{file.extension.downcase}" if original_filename
    end
  end


#def get_version_dimensions
    #if model
      #width, height = `identify -format "%wx%h" #{file.path}`.split(/x/)
      #puts "#{width} , #{height} , #{file.path}"
    #end
  #end

#after :store, :getv
after :store, :time_end

def time_start
  puts "----------------------------------------------------------------------------------------------"
  puts Time.now
  puts "----------------------------------------------------------------------------------------------"
end

def time_end(file)
puts "----------------------------------------------------------------------------------------------"
  puts Time.now
  puts "----------------------------------------------------------------------------------------------"

  end


#def getv(file)
  #str = RestClient.get model.avatar.url+"!text"
  #json = JSON.parse str
  #new_hash = {}
  #json.each_key do |key|
    #key = key.to_sym

  #end

  #p new_hash[:width]
#end

end
