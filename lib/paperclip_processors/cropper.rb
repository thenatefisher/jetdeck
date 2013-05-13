module Paperclip
  class Cropper < Thumbnail

    def transformation_command
        " -scale '1200' -gravity Center -crop 'x400+0+0' +repage "
    end

  end
end