# Docker Image to Compile NSIS scripts

[NSISBI][1] aims to remove the current 2GB limit found in NSIS.

## How to use this image

Use powershell to create an installer:

```powershell
docker run -it --rm --mount "type=bind,src=$($pwd)/Examples,target=/app" kaimingguo/nsisbi example2.nsi
```

## Plugins

- [AccessControl][2] (1.0.8.3)
- [NsProcess][5] (1.6)
- [NSxfer][6] (v1.2023.8.4)
- [NSIS Simple Firewall Plugin][7] (1.21)
- [NSIS Simple Service Plugin][8] (1.30)

## License

This repository's source is licensed under the [MIT License](./LICENSE).

[1]: https://sourceforge.net/projects/nsisbi
[2]: https://nsis.sourceforge.io/AccessControl_plug-in
[5]: https://nsis.sourceforge.io/NsProcess_plugin
[6]: https://github.com/negrutiu/nsis-nsxfer
[7]: https://nsis.sourceforge.io/NSIS_Simple_Firewall_Plugin
[8]: https://nsis.sourceforge.io/NSIS_Simple_Service_Plugin
