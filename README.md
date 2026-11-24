# hwconfig

Bash-script til Ubuntu, der viser computerens hardware- og systemkonfiguration i terminalen. Udarbejdet af Ib Helmer Nielsen.

## Installation

```bash
sudo apt update
sudo apt install git pciutils usbutils lshw dmidecode lm-sensors iproute2
git clone https://github.com/ibhelmer/hwconfig.git
cd hwconfig
chmod +x hwconfig.sh
```

## Anvendelse

```bash
./hwconfig.sh
sudo ./hwconfig.sh
./hwconfig.sh --help
```

Den første kommando viser grundlæggende oplysninger uden root. Den anden giver også detaljer om hardware og RAM-moduler. Manglende valgfrie værktøjer rapporteres, og scriptet fortsætter.

Gem en rapport lokalt:

```bash
sudo ./hwconfig.sh > hardware-report.txt 2>&1
```

## Hvilke oplysninger vises?

- Operativsystem, kernel og virtualisering.
- CPU-arkitektur, kerner og tråde.
- RAM og swap, samt fysiske RAM-moduler med root.
- Bundkort, BIOS og producent.
- Diske, transporttype, filsystemer og diskforbrug.
- PCI-enheder, GPU, netværkskort og drivere.
- USB-enheder, netværksinterfaces og IP-adresser.
- Hardwareoversigt og temperaturer, når understøttet.

## Sikkerhed og begrænsninger

Scriptet læser oplysninger og ændrer ikke systemets konfiguration. Det sender ikke rapporter til eksterne tjenester. Rapporter kan dog indeholde værtsnavn, maskin-ID, IP- og MAC-adresser samt andre identificerende oplysninger. Gennemgå derfor rapporten inden deling. Gem ikke rapporter i et offentligt Git-repository. På virtuelle maskiner ses primært den virtuelle hardware; sensorer og DMI-information kan mangle.

## Licens

Copyright 2026 Ib Helmer Nielsen.

Apache License, Version 2.0. Se [LICENSE](LICENSE) eller https://www.apache.org/licenses/LICENSE-2.0.
