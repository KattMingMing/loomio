class DetectLocaleController < ActionController::Base
  layout false
  include LocalesHelper
  include CurrentUserHelper

  def show
    d = best_locale(detected_locale(Translation.frontpage_locales))
    if current_locale != d
      I18n.locale = d
      Measurement.increment('detect_locale.foreign')
    else
      Measurement.increment('detect_locale.default')
      head :ok
    end
  end

  def video
    locale = best_locale(detected_locale(Translation.video_locales))

    if locale == :en
      Measurement.increment('detect_video_locale.default')
      head :ok
    else
      Measurement.increment('detect_video_locale.foreign')
      render text: locale
    end
  end

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
