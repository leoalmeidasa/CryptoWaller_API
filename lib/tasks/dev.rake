namespace :dev do
  desc 'Configurando o ambiente'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Apagando BD...') { %x(rails db:drop) }
      show_spinner('Criando BD...') { %x(rails db:create) }
      show_spinner('Migrando BD...') { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else
      puts 'Você não está em ambiente de desenvolvimento!'
    end
  end

  desc 'Cadastrando moedas'
  task add_coins: :environment do
    show_spinner('Cadastrando moedas...') do
      coins = [
                { description: 'Bitcoin', acronym: 'BTC',
                  url_image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fclipartart.com%2Fimages%2Fbitcoin-clipart-logo-9.jpg&f=1&nofb=1',
                  mining_type: MiningType.find_by(acronym: 'PoW')
                },

                { description: 'Dash', acronym: 'DASH',
                  url_image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.ujIhOQ8F-Rm91hOWUnTy0gHaHa%26pid%3DApi&f=1',
                  mining_type: MiningType.all.sample
                },

                { description: 'Ethereum', acronym: 'ETH',
                  url_image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.9zcmgT_H3m4SuFW7p6MnkgHaLz%26pid%3DApi&f=1',
                  mining_type: MiningType.all.sample
                }
              ]

      coins.each do |coin|
      Coin.find_or_create_by!(coin)
      end
    end
  end

  desc 'Cadastrando os tipos de mineração'
  task add_mining_types: :environment do
    show_spinner('Cadastrando tipos de mineração...') do
      mining_types = [
        {description: 'Proof of Work', acronym: 'PoW'},
        {description: 'Proof of Strake', acronym: 'PoS'},
        {description: 'Proof of Capacity', acronym: 'PoC'}]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private

  def show_spinner(msg_start) 
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success('(Concluido com sucesso !)')
  end
end