# register interceptor for staging environment
ActionMailer::Base.register_interceptor(StagingEmailInterceptor) if Rails.env.staging?