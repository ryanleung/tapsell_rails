class EmailValidator < ActiveModel::EachValidator

  @@email_pattern = nil

  def self.email_pattern
    unless @@email_pattern
      atext = /[A-Za-z0-9!#\$%&'\*\+\-\/=\?\^_`\{\|\}\~]/
      dot_atom = /(?:#{atext})+(?:\.(?:#{atext})+)*/

      text = /[\x01-\x09\x0B\x0C\x0E-\x7F]/
      qtext = /[\x01-\x08\x0B\x0C\x0E-\x1F\x21\x23-\x5B\x5D-\x7E]/
      quoted_pair = /\\#{text}/
      qcontent = /(?:#{qtext}|#{quoted_pair})/
      quoted_string = /"(?:\s*#{qcontent})*\s*"/

      dtext = /[\x01-\x08\x0B\x0C\x0E-\x1F\x21-\x5A\x5E-\x7E]/
      dcontent = /(?:#{dtext}|#{quoted_pair})/
      domain_literal = /\[(?:\s*#{dcontent})*\s*\]/
      domain = /(?:#{dot_atom}|#{domain_literal})/

      local_part = /(?:#{dot_atom}|#{quoted_string})/

      @@email_pattern = /\A(#{local_part})@(#{domain})\z/
      # @@email_pattern = Regexp.new("/\A#{addr_spec}\z/", nil, 'n')
    end

    @@email_pattern
  end

  # A general email regular expression. It allows top level domains (TLD) to
  # be from 2 - 4 in length, any TLD longer than that must be manually
  # specified. The decisions behind this regular expression were made by
  # reading this website: http://www.regular-expressions.info/email.html,
  # which is an excellent resource for regular expressions.

  # def self.email_pattern
  #   unless @@email_pattern
  #     email_name_regex  = '[A-Z0-9_\.%\+\-]+'
  #     domain_head_regex = '(?:[A-Z0-9\-]+\.)+'
  #     domain_tld_regex  = '(?:[A-Z]{2,4}|museum|travel)'
  #     @@email_pattern = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
  #   end
  #   @@email_pattern
  # end

  def validate_each(record, attribute, value)
    unless value =~ self.class.email_pattern
      record.errors.add attribute, "does not have a valid email address format"
    end
  end
end
