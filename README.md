# Omie Client for Ruby

[Omie](https://app.omie.com.br/developer/service-list/) client for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omie-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omie-client

## Usage

To use the lib you must set the credentials to use your Omie instance. First,
you need to create the keys at
[Omie developer page](https://developer.omie.com.br/my-apps/)
or [Omie generate keys](https://app.omie.com.br/developer/generate-key/).
Then, set your credentials:
```ruby
require 'omie'
Omie.app_key = "app_key"
Omie.app_secret = "app_secret"
```

**Now that the cliet is properly initialized you can start using it's
functions.**

The available classes of the Omie client corresponds the resources available in
Omie's API.

The lib follows the same design principles of Rail's ActiveRecord.
Each class provides a set of methods that perform direct calls to
Omie's API and return a Plain Old Ruby Objects (PORO) for each corresponding
entry. The resources' instance variables have the same portuguese names of
attributes of their respective JSON payloads.

The available resources are:

* Company (Clientes)

Ongoing Work:

* Procut (Produtos)
* SalesOrder (Ordem de Venda)

Future Versions:

* PurchaseOrder (Ordem de Compra)

### Company Resource

This class aims at manipulating resources available for Omie's companies,
including clients and providers.

> Ref: [Company documentation](https://app.omie.com.br/api/v1/geral/clientes/)

To create a new Company resource you can:
```ruby
company = Omie::Company.create(codigo_cliente_integracao: "XPTO_INTERNAL_CODE", cnpj_cpf: '26742035000190', nome_fantasia: 'Peerdustry Tecnologia LTDA', razao_social: 'Peerdustry Manufatura Compartilhada', email: 'contato@peerdustry.com')

# Update the email locally
company.email = "another@peerdustry.com"

# Update the register on Omie
company.save
```

Search for a specific entry:
```ruby
company = Omie::Company.find(cnpj_cpf: '26742035000190')
```

List all entries:
```ruby
companies = Omie::Company.list
puts companies.class # Array

puts companies.count
companies.each {|c| puts c.nome_fantasia }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome. If you want to add a new resource
from the API, please open an issue first to avoid duplicated work.

### Building and Testing Locally

To properly test if the gem is working properly, you can install it locally:
```sh
gem build omie-client.gemspec
gem install ./omie-client-x.y.z.gem
```
The `x.y.z` represents the version described in [lib/omie/version.rb](lib/omie/version.rb)

You can make some smoke test to check if everything is ok, especially because
this gem interacts with Omie API, requiring some integration tests that
is not covered by the existing unit tests.
* Open irb:
```sh
irb
```

```ruby
require 'omie'
=> true
Omie::VERSION
=> "x.y.z"
# Default credentials provided by Omie API for tests
Omie.app_key = '1560731700'
Omie.app_secret = '226dcf372489bb45ceede61bfd98f0f1'

Omie::Company.list
Omie::Product.list
```

If everything is working fine and you have the proper credentials to upload
the new version, run:

```sh
gem push omie-client-x.y.z.gem
Pushing gem to RubyGems.org...
Successfully registered gem: omie-client (x.y.z)
```
> You may need to authenticate at rubygems first => https://guides.rubygems.org/make-your-own-gem/

## License

See the [LICENSE](LICENSE) file.

