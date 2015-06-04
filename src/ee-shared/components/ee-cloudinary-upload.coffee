angular.module 'ee-cloudinaryUpload', []

angular.module('ee-cloudinaryUpload').directive "eeCloudinaryUpload", (eeDefiner) ->
  templateUrl: 'ee-shared/components/ee-cloudinary-upload.html'
  restrict: 'E'
  replace: true
  scope:
    attrTarget: '='
  link: (scope, element, attrs) ->
    form = element

    scope.user  = eeDefiner.exports.user
    username    = scope.user.username
    form
      .append $.cloudinary.unsigned_upload_tag "storefront_home", {
          cloud_name: 'eeosk',
          tags: 'browser_uploads', username
        }

    assignAttr = (data) ->
      if scope.attrTarget is 'carousel' then scope.user.storefront_meta.home.carousel[0].imgUrl = data.result.secure_url
      if scope.attrTarget is 'about' then scope.user.storefront_meta.about.imgUrl = data.result.secure_url

    resetProgress = () ->
      scope.progress = 0
      scope.partialProgress = 5

    bindCloudinary = () ->
      form
        .bind 'cloudinarydone', (e, data) ->
          resetProgress()
          unbindCloudinary()
          assignAttr(data)
          scope.$apply()
          bindCloudinary()
          # $('.carousel img').append($.cloudinary.image(data.result.public_id,
          #   {
          #     format: 'jpg',
          #     width: 150,
          #     height: 100,
          #     crop: 'thumb',
          #     gravity: 'face',
          #     effect: 'saturation:50'
          #   }
          # ))
        .bind 'cloudinaryprogress', (e, data) ->
          percentage = Math.round((data.loaded * 100.0) / data.total)
          # Only scope.$apply periodically
          if percentage > scope.partialProgress
            scope.partialProgress = percentage + 5
            scope.progress = if scope.progress > 99 then 0 else percentage
            scope.$apply()

      unbindCloudinary = () ->
        form.unbind 'cloudinaryprogress'
        form.unbind 'cloudinarydone'

    resetProgress()
    bindCloudinary()
    return
