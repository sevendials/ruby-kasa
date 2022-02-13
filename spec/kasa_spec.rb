# frozen_string_literal: true

RSpec.describe Kasa do
  let :package do
    described_class.new '192.168.1.118'
  end

  let :response_encrypted do
    Base64.decode64 '
      0PKB+Iv/mvfV75S20bTAn+yV5o/hh+jK8Iup2q3yhOGTsYupmLaGqJmoiMq/
      1rre/sz9zPzN/t6M6YWrmq2dpZeggq6M5JPMut+tj7WXpYu7mbWX+pXxlPja
      4MKK2era6sKXxO3P48GlwLbfvNmQ9NbszvbG9sD2t4DDh7eHxPayh7GIyfDG
      gsHwsfey87eFsPSyg8X1wvGz9czuwuCP6ofOqoiykKOR05en5dfmp+bfndvj
      pp6qna6Z3eyo6tuYrpjd5d3uzODCqt2U8NLoyvPG87WBsoHCgMHzx//N/r+N
      uYHA9cyNzPrO+8z9vIu4mraU5pXmj62Xuoi5lbfbus6n06bCp/iRs4m5lbfb
      tNq91KDVsdSL4sD6yubEpcmgwbKQqojcjKHtpOqh/q7BttOhgdKm1L3NktaS
      opS2mrjLv96q36yOtJb4nerI5MarwqH+ivOD5sT+3JXajqDzvv+t+anlsPek
      87rureXH68mvyqvfqti9n6WH05rX7ajmo4Gtj+KD4ML42pioktPk3pyln6eX
      remtl6eRs5+9yLjcvcmgzqmLsYGtj+OG4r3StNLwyvrW9Jf/lvqe7Innxf+k
      3/2U8NLoyvLC8sTys4THg7ODwPK2g7WMzfTChsX0tfO297OBtPC2h8HxxvW3
      8cj4yOrG5JfjgvaTsYu6lrTVudCxwuDa+KjEsdb2x+XJ64TqtcGoxaCCuIC3
      jrqIvZGz3bjAtOuK6Z30m/XX7Za0wLnJrI60majVqIT/3bTQ8sjq0uLS5NKT
      pOejk6Pg0pajlazt1OKm5dSV05bXk6GU0Jan4dHm1ZfR6Njpy+fFtsKj17KQ
      qpu3lfSY8ZDjwfvZieWQ99flx+vJpsiX44rngqCaopWsmKqfs5H/muKWyajL
      v9a51/XPtJbim+uOrJa7iveKpt3/lvLQ6sjwwPDG8LGGxYGxgcLwtIG3js/2
      wITH9rfxtPWxg7bytIXD88T3tfPK+sjqxuSX44L2k7GLupa01bnQscLg2vio
      xLHW9sXny+mG6LfDqseigLqCtYy4ir+Tsd+6wrbpiOuf9pn31e+UtsK7y66M
      tpuq16qG/d+20vDK6NDg0ObQkabloZGh4tCUoZeu79bgpOfWl9GU1ZGjltKU
      pePT5NeV0+ra6cvnxbbCo9eykKqbt5X0mPGQ48H72YnmkfSGptK9nfGY7ofp
      jq7cs9yxkcWTsZ2/0L7hlfyR9Nbs1OPa7tzpxeeJ7JTgv969yaDPoYO5wuCU
      7Z342uDN/IH80KuJ4ISmnL6Gtoawhsfws/fH97SGwvfB+LmAtvKxgMGHwoPH
      9cCEwvO1hbKBw4W8jLiatpTnk/KG48H7yubEpcmgwbKQqojYt8Cl1/eD7My/
      0KXLr4/tjP7c8NK904z4kfyZu4G5jreDsYSoiuSB+Y3Ss9CkzaLM7tSvjfmA
      8JW3jaCR7JG9xuSN6cvx0+vb693rqp3emqqa2euvmqyV1O3bn9ztrOqv7qqY
      remvntjo3+yu6NHh1Pba+Iv/nuqPrZeni6nIpM2s3/3H5anAtt+x1vaE64Tp
      yavKqcLijueA6JzvzeHDrMKd6YDtiKqQoIyuwKXdqfaX9IDphujK8Iup3aTU
      sZOphLXItejE5oXthOiM073IpYe9i6eF4JLgv9yz17KQqprnmuc='
  end

  let :response do
    {
      'alias' => 'TP-LINK_Power Strip_DD06',
      'child_num' => 6,
      'children' => [
        {
          'alias' => 'Plug 1',
          'id' => '80066A7CD00C2D569A96DC1AFEAD25DF1F073BF900',
          'next_action' => { 'type' => -1 },
          'on_time' => 879_425,
          'state' => 1
        },
        { 'alias' => 'Plug 2',
          'id' => '80066A7CD00C2D569A96DC1AFEAD25DF1F073BF901',
          'next_action' => { 'type' => -1 },
          'on_time' => 879_425,
          'state' => 1 },
        { 'alias' => 'Plug 3',
          'id' => '80066A7CD00C2D569A96DC1AFEAD25DF1F073BF902',
          'next_action' => { 'type' => -1 },
          'on_time' => 879_425,
          'state' => 1 },
        { 'alias' => 'Power to living room TV',
          'id' => '80066A7CD00C2D569A96DC1AFEAD25DF1F073BF903',
          'next_action' => { 'type' => -1 },
          'on_time' => 879_425,
          'state' => 1 },
        { 'alias' => 'Power to sound bar',
          'id' => '80066A7CD00C2D569A96DC1AFEAD25DF1F073BF904',
          'next_action' => { 'type' => -1 },
          'on_time' => 879_425,
          'state' => 1 },
        { 'alias' => 'Living room back lights',
          'id' => '80066A7CD00C2D569A96DC1AFEAD25DF1F073BF905',
          'next_action' => { 'type' => -1 },
          'on_time' => 0,
          'state' => 0 }
      ],
      'deviceId' => '80066A7CD00C2D569A96DC1AFEAD25DF1F073BF9',
      'err_code' => 0,
      'feature' => 'TIM:ENE',
      'hwId' => '955F433CBA24823A248A59AA64571A73',
      'hw_ver' => '2.0',
      'latitude_i' => 0,
      'led_off' => 0,
      'longitude_i' => 0,
      'mac' => 'B0:A7:B9:80:DD:06',
      'mic_type' => 'IOT.SMARTPLUGSWITCH',
      'model' => 'HS300(US)',
      'oemId' => '32BD0B21AA9BF8E84737D1DB1C66E883',
      'rssi' => -21,
      'status' => 'new',
      'sw_ver' => '1.0.11 Build 211013 Rel.170827',
      'updating' => 0
    }
  end

  it 'has a version number' do
    expect(Kasa::VERSION).not_to be nil
  end

  it 'does something useful' do
    allow(Kasa::Protocol).to receive(:transport).and_return(response_encrypted)
    expect(package.sysinfo).to eq(response)
  end
end
