def parse_binary_ip(ip_bin_str):
    """Преобразует строку вида '10101100.01000000.00000000.00000000' в список октетов"""
    return [int(octet, 2) for octet in ip_bin_str.split('.')]


def invert_octets(octets):
    return [~octet & 0xFF for octet in octets]


def bitwise_or(octets1, octets2):
    return [a | b for a, b in zip(octets1, octets2)]


def format_ip_binary(octets):
    return '.'.join(f'{octet:08b}' for octet in octets)


def format_ip_decimal(octets):
    return '.'.join(str(octet) for octet in octets)


ip1_bin_str = input("введите IP:\n")
# mask_bin_str = input("введите маску:\n")
mask_bin_str = '11111111.11111111.11000000.00000000'

ip1_octets = parse_binary_ip(ip1_bin_str)
mask_octets = parse_binary_ip(mask_bin_str)

mask_inverted = invert_octets(mask_octets)
print('mask inverted = ', mask_inverted)

broadcast_octets = bitwise_or(ip1_octets, mask_inverted)

print("Результат (в двоичном виде):", format_ip_binary(broadcast_octets))
print("Результат (в десятичном виде):", format_ip_decimal(broadcast_octets))
