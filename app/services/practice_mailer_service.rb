class PracticeMailerService
  def self.call(subject:, message:, current_user:, filters:)
    new(subject: subject, message: message, current_user: current_user, filters: filters).call
  end

  def initialize(subject:, message:, current_user:, filters:)
    @subject = subject
    @message = message
    @current_user = current_user
    @filters = filters
    @practice_ids_to_update = Set.new
    @practice_names = Set.new
  end

  def call
    user_practices_data = collect_users_and_their_practices_info
    send_emails(user_practices_data)
    update_last_email_date_for_practices
  end

  private

  attr_reader :subject, :message, :current_user, :filters, :practice_names, :practice_ids_to_update

  def collect_users_and_their_practices_info
    practices = Practice.joins(:user).ransack(filters).result(distinct: true)

    user_practices = practices.each_with_object({}) do |practice, hash|
      next unless practice.user.present? && practice.published?
      hash[practice.user] ||= Set.new
      hash[practice.user] << practice
      practice_names << practice.name
      practice_ids_to_update << practice.id
    end

    editor_practices = PracticeEditor.joins(:user, :practice).where(practice_id: practices.ids)
    editor_practices.each_with_object(user_practices) do |editor, hash|
      next unless editor.user.present? && editor.practice.published?
      hash[editor.user] ||= Set.new
      hash[editor.user] << editor.practice
      practice_names << editor.practice.name
      practice_ids_to_update << editor.practice.id
    end

    if Rails.env.production? && ENV['PROD_SERVERNAME'] != 'PROD'
      user_practices = user_practices.select { |user, _| user == current_user }
    end

    format_user_practices(user_practices)
  end

  def send_emails(user_practices_data)
    mailer_args = {
      "subject" => @subject,
      "message" => @message
    }
    user_practices_data.each do |user_practices|
      mailer_args["practices_data"] = user_practices
      PracticeMailerWorker.perform_async("send_batch_email_to_editor", mailer_args)
    end

    send_confirmation_email(mailer_args)
  end

  def send_confirmation_email(mailer_args)
    mailer_args["practices_data"] = @practice_names.to_a
    mailer_args["filters"] = (@filters.values.all?("") ? [] : @filters.transform_keys(&:to_s))
    mailer_args["sender_email_address"] = @current_user.email

    PracticeMailerWorker.perform_async("send_batch_email_confirmation", mailer_args)
  end

  def update_last_email_date_for_practices
    Practice.where(id: practice_ids_to_update.to_a).update_all(last_email_date: Time.current)
  end

  def format_user_practices(user_practices)
    user_practices.map do |user, practices|
      {
        "user_info" => { "user_name" => user.first_name, "email" => user.email },
        "practices" =>  practices.map { |practice| format_practice_for_mailer(practice) }
      }
    end
  end

  def format_practice_for_mailer(practice)
    host_options = Rails.application.config.action_mailer.default_url_options
    {
      "practice_name" => practice.name,
      "show_url" => Rails.application.routes.url_helpers.practice_url(practice, host_options),
      "practice_id" => practice.id,
      "last_updated_on" => practice.updated_at.strftime('%m/%d/%Y')
    }
  end
end
