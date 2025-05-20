import ipaddress
import math


def split_network(ip_str, original_prefix, n):
    original_network = ipaddress.IPv4Network(f'{ip_str}/{original_prefix}', strict=False)

    subnet_bits = math.ceil(math.log2(n + 1))  # +1, чтобы обеспечить n ненулевых
    new_prefix = original_network.prefixlen + subnet_bits

    if new_prefix > 32:
        print("Ошибка: невозможно создать столько подсетей — маска превышает /32.")
        return

    subnets = list(original_network.subnets(new_prefix=new_prefix))

    valid_subnets = subnets[1:n + 1]

    print(f'\nИсходная сеть: {original_network}')
    print(f'Новая длина маски: /{new_prefix} ({ipaddress.IPv4Network("0.0.0.0/" + str(new_prefix)).netmask})\n')
    print(f'Подсети (без нулевой):')
    for i, net in enumerate(valid_subnets, start=1):
        print(f'{i}: {net}')


ip = input('Введите IP-адрес сети (например, 172.16.0.0): ')
prefix = int(input('Введите длину маски исходной сети (например, 16): '))
n = int(input('Введите количество подсетей: '))

split_network(ip, prefix, n)
