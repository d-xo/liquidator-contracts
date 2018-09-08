saiKovan = 0xa71937147b55deb8a530c7229c442fd3f31b7db2 
saiMainnet = 0x448a5065aebb8e423f0896e6c5d525c040f59af3

all    :; dapp build
clean  :; dapp clean
test   :; dapp test
deploy-kovan :; SETH_CHAIN=kovan dapp create Liquidator $(saiKovan)
deploy-mainnet :; SETH_CHAIN=ethlive dapp create Liquidator $(saiMainnet) 
