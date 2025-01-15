class CommentMailer < ApplicationMailer
    default from: 'do_not_reply@va.gov'
    layout 'mailer'

    def report_comment_email(options = {})
        @comment = Commontator::Comment.find(options[:id])
        subject = "A comment has been reported"

        mail(to: 'marketplace@va.gov', subject: subject)
    end
end
