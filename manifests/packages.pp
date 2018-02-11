# Install class for Postfix.

class postfix::packages {

  package{ 'postfix': }
  package {'cyrus-sasl-plain': }
  package {'cyrus-sasl-md5': }

}
