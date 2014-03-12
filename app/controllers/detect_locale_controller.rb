class DetectLocaleController < ActionController::Base
  include LocalesHelper
  include CurrentUserHelper

  def show
    d = detected_locale(Translation.frontpage_locales)
    if d.present? and (current_locale != d)
      I18n.locale = d
      Measurement.increment('detect_locale.foreign')
    else
      Measurement.increment('detect_locale.default')
      head :ok
    end
  end

  def video_show
    lang = detected_locale(Translation.video_locales)

    if lang.present? && lang != :en
      Measurement.increment('detect_video_locale.foreign')

      render text: lang
    else
      Measurement.increment('detect_video_locale.default')

      head :ok
    end
  end

#### JS for Crowdtilt
  # $(function() {
  #   return $.ajax({
  #     url: "http://127.0.0.1:3000/detect_video_locale",
  #     dataType: 'text/html',
  #     success: function(data) {
  #       var modififier = '&cc_load_policy=1&cc_lang_pref=' + data;

  #       console.log(data);
  #       alert(data);
  #       alert(modififier);

  #       // var param_tag = document.getElementsByName('movie')[0];
  #       // param_tag.value = param_tag.value + modififier;

  #       // var embed_tag = document.getElementsByTagName('embed')[0];
  #       // embed_tag.src = embed_tag.src + modififier;
  #     }
  #   });
  # });



  private
  def current_locale
    locale = (Translation.locale_strings & [params[:current_locale]]).first

    if locale.present?
      locale.to_sym
    else
      default_locale
    end
  end
end
