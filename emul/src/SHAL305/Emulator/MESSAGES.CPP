#include "main.hpp"
#include "messages.hpp"

char TxtNul[]="";
char TxtROM[]="\1ROM";
char TxtBeep[]="\1Beeper";

#ifdef Rus

char ButtOK[]="\1ОК";
char PrMes[]="Эмулятор ZX-Spectrum  " Ver "\n(c) 1995-1999 Николай Шалаев\n";
char ProgName[]="Эмулятор ZX-Spectrum";
char ButtStart[]="\1Старт";
char TxtConfig[]="\1Конфигурация";
char TxtCfg[]="\1Настройка";
char TxtUtil[]="\1Утилиты";
char TxtUtilDiskToFile[]="Копирование диска в файл";
char TxtUtilFileToDisk[]="Восстановление диска из файла";
char TxtCont[]="\1Продолжение";
char TxtInfo[]="\1Информация";
char TxtExit[]="В\1ыход";
char TxtPath[]="\1Пути";
char TxtFileCh[]="Выбор файла";
char TxtFileName[]="Имя файла";
char TxtDisks[]="Диски";
char TxtSave[]="\1Сохранение";
char TxtOpSuc[]="Операция завершена успешно";
char ButtCanc[]="О\1тмена";
char ButtYes[]="\1Да";
char ButtNo[]="\1Нет";
char TxtWrPr[]="Защита записи";
char TxtSure[]="Вы уверены?";
char TxtErPth[]="Путь не найден: ";
char TxtErDisk[]="Ошибка диска";
char TxtErNoFile[]="Нет файла: ";
char TxtErFOpen[]="Ошибка при открытии файла: ";
char TxtErFRead[]="Ошибка при чтении файла: ";
char TxtErFSave[]="Ошибка при записи файла: ";
char TxtErAdLib[]="Ошибка инициализации Ad Lib";
char TxtErSndBl[]="Ошибка инициализации Sound Blaster";
char TxtErNotCorF[]="Некорректный файл: ";
char TxtErBadVer[]="Неподдерживаемая версия файла: ";
char TxtErNoMem[]="Недостаточно памяти для загрузки: ";
char TxtRetry[]="\1Повторить";
char TxtAbort[]="О\1тменить";
char TxtIgnore[]="\1Игнорировать";
char TxtJoyK[]="\1Kempston джойстик";
char TxtJoyS[]="\1Sinclair джойстик";
char TxtHlp[]="Помощь";
char TxtHlpSw[]="\nИспользование: SPECTRUM [-<Опция>...] [<Диск A> <Диск B>...]\nПример: SPECTRUM -S DISK.TRD\nОпции:\n H - помощь\n S - быстрый старт";
char TxtHlpMain[]="Для первого запуска, а также для последующих запусков эмулятора без сохранения текущих данных используйте кнопку \1\"Старт\".\1 Для повторного запуска эмулятора с сохранением загруженной программы и текущих данных ZX-Spectrum (чтобы продолжить работу в эмуляторе на том месте, где она была прервана) используйте кнопку \1\"Продолжение\"\1. Эта кнопка появляется после первого запуска эмулятора. Изменение настроек эмулятора Вы можете произвести после нажатия кнопки \1\"Конфигурация\"\1 в соответствующей панели диалога. "
	"Если Вы запускаете эмулятор впервые, то, скорее всего, Вам понадобится выбрать файлы ROM и образы дисков TR-DOS. "
	"Текущее значение дисков TR-DOS отражено в этом меню (\1\"Диск A\"\1, \1\"Диск B\"\1...). "
	"С помощью дисковых утилит, запуск которых производится кнопкой \1\"Утилиты\"\1, можно скопировать диск в файл (создать образ диска, с которым эмулятор работает как с диском TR-DOS) и восстановить его из файла. "
	"\1\"Модули\"\1 - подключение и конфигурирование дополнительных модулей. "
	"\1\"Информация\"\1 - информация о программе. Для выхода из программы используйте кнопку \1\"Выход\"\1.";
char TxtHlpCfg[]="Имена файлов образа диска Вы можете ввести в строках \1\""
	"Диск A\"\1, \1\"Диск B\"\1... Для выбора файла из списка используйте кнопку \1\"Пролистать\"\1. "
	"\1\"Пути\"\1 - выбор директорий для расположения файлов образа диска, ROM и модулей. "
	"\1\"ROM\"\1 - настройка ROM: выбор файлов ROM и пути к ним. \1\"Звук\"\1 - установка звуковых карт для эмуляции музыкального синтезатора AY, настройка параметров звуковых карт, включение и выключение эмуляции Beeper на PC-Speaker. \1\"Управление\"\1 - установка джойстика и мыши, а также их настройка. \1\"Скорость\"\1 - установка скоростных параметров эмулятора. \1\"Дополнительно\"\1 - включение и выключение автосохранения конфигурации, выбор режима рестарта, настройка прерываний и прочих режимов, связанных с особенностями эмуляции Spectrum. При помощи кнопки \1\"Сохранение\"\1 Вы можете сохранить установленную конфигурацию в файле \"SPECTRUM.INI\". После перезапуска эмулятор будет сконфигурирован в соответствии с этим файлом.";
char TxtHlpUtil[]="Эмулятор работает с файлами образа диска TR-DOS, которые являются копиями оригинальных дисков. Дисковые утилиты предназначены для копирования содержимого реального диска TR-DOS в файл в формате эмулятора и назад. \1\"Диск в файл\"\1 - копирование диска в файл (создание файла образа диска на основе реального диска TR-DOS). \1\"Файл на диск\"\1 - восстановление диска из файла. С помощью строки \1\"Имя файла для диска\"\1 можно ввести имя файла, с которым будут работать утилиты. Для выбора файла из списка используйте кнопку \1\"Пролистать\"\1. Выбор дисковода для работы с дисками TR-DOS осуществляется с помощью переключателя \1\"Дисковод для утилит\"\1. Если включено \1\"Форматирование\"\1 диск будет отформатирован перед восстановлением.";
char TxtHlpPath[]="\1\"Путь для дисков\"\1 - директория, которая используется эмулятором и дисковыми утилитами как местоположение файлов образа диска. "
	"\1\"Путь для ROM\"\1 - директория, в которой находятся файлы ROM. "
	"\1\"Путь для модулей\"\1 - директория, в которой находятся добавочные модули к эмулятору. "
	"Для выбора текущей директории наберите: \".\" (точка).";
char TxtHlpROM[]="Для работы эмулятора необходимы файлы ROM, которые являются копиями оригинальных ROM. В каждой из строк: \1\"Файл ROM 48\"\1, \1\"Файл ROM 128\"\1 и \1\"Файл ROM TR-DOS\"\1 введите имя файла, соответствующего данной строке. Для выбора файла из списка используйте кнопку \1\"Пролистать\"\1.";
char TxtHlpSound[]="Если флажок \1\"Beeper\"\1 установлен, то эмуляция Beeper включена (звук воспроизводится на PC-Speaker). "
	"Звуковую карту для эмуляции музыкального синтезатора AY можно выбрать, установив соответствующий пункт переключателя \1\"Звуковая карта\"\1. "
	"Если выбран Sound Blaster, то необходимо установить его параметры: адрес порта и громкость. "
	"\1\"Адрес SB\"\1 - базовый адрес Sound Blaster. "
	"\1\"Громкость\"\1 - громкость цифрового звука. "
	"Она нужна для изменения громкости цифрового звука по отношению к громкости FM-синтеза (может принимать значения от 0 до 128, по умолчанию - 80). "
	"Если выбран Ad Lib или Sound Blaster, то установкой параметра \1\"Циклы ожидания Ad Lib\"\1 Вы можете уменьшить потери времени на обращение к звуковой карте. "
	"Чем меньше значение этого параметра, тем быстрее работает эмулятор. "
	"\1\"Огибающая\"\1 - разрешающая способность генератора огибающей по времени. "
	"Чем выше это значение, тем точнее эмулируется огибающая, но тем медленее работает эмулятор.";
char TxtHlpInput[]="Эмулятор имеет поддержку аналогового джойстика и мыши. Если установлен флажок \1\"Kempston джойстик\"\1, то джойстик подключен как Kempston Interface I и II. При установке флажка \1\"Sinclair джойстик\"\1 джойстик опрашивается как Sinclair джойстик (Interface II). Выбрать тип подключенной мыши можно установив переключатель \1\"Тип мыши\"\1. В пунктах \1\"Скорость мыши по X\"\1 и \1\"Скорость мыши по Y\"\1 можно установить скорости перемещения мыши по осям в процентах (устанавливаемая величина может принимать значение от 10 до 200, по умолчанию - 100). Чтобы поменять местами левую и правую кнопки мыши, установите флажок \1\"Смена кнопок мыши\"\1.";
char TxtHlpSpeed[]="В этой панели диалога можно настроить скоростные параметры эмулятора. Переключатель \1\"Скорость\"\1 может принимать значения: \"Нормальная\" - скорость близка к скорости реального Spectrum; \"Максимальная\" - максимально возможная скорость; \"Ускоренная\" - примерно на 1/8 быстрее нормальной; \"Замедленная\" - примерно на 1/8 медленнее нормальной; \"Выборочная\" - скорость зависит от установленных значений \1\"Параметры скорости\"\1. \1\"Основной\"\1 - параметр, влияющий на скорость в целом: чем больше значение этого параметра, тем медленее работает эмулятор. \1\"Пиксели\"\1 и \1\"Атрибуты\"\1 - скоростные параметры экрана. Чем больше эти параметры, тем быстрее происходит запись в видеопамять (на чтение из видеопамяти не влияют). При установке флажка \1\"Максимальная скорость в TR-DOS\"\1 скорость при работе TR-DOS будет максимальной независимо от установки параметра \"Скорость\".";
char TxtHlpAdv[]=	"Параметр \1\"Частота кадров\"\1 определяет частоту кадров видеоадаптера (стандартное для ZX-Spectrum значение - 50 Hz). "
	"В опции \1\"Источник прерываний\"\1 Вы можете выбрать устройство, которое будет вызывать кадровое прерывание в эмуляторе. "
	"Если Вы выбрали \"Прерывание VGA\", то Вам нужно установить необходимое значение параметра \1\"IRQ VGA\"\1. "
	"При выборе значения \"Таймер\" частота кадровых прерываний зависит от значения (от 20 до 100, по умолчанию - 50) параметра \1\"Частота прерываний\"\1. "
	"\1\"Длительность прерывания\"\1 - количество команд процессора, в течение которых активен импульс прерывания (значения от 1 до 100, по умолчанию - 1). \1\"Длина данных форматирования\"\1 - количество байт, которое принимает ВГ93 при команде \"Запись дорожки\" (значения от 1 до 16384, по умолчанию - 1). "
	"Переключатель \1\"Режим рестарта\"\1 влияет на режим эмулятора после запуска. "
	"Флажок \1\"Постоянная готовность диска\"\1 устанавливает режим работы ВГ93, при котором работа с диском происходит быстрее, а совместимость с оригиналом ниже. "
	"\1\"Монохромный режим\"\1 - черно-белый режим. "
	"При включении опции \1\"Автосохранение конфигурации\"\1 эмулятор автоматически сохраняет текущую конфигурацию.";
char TxtHlpDisks[]="В этой панели диалога Вы можете заменить файлы образа диска TR-DOS для работы с ними в эмуляторе и установить значение атрибута \"Защита записи\" для любого из подключенных файлов. Имена файлов можно ввести в строках \1\"Диск A\"\1, \1\"Диск B\"\1... Для выбора файла из списка используйте кнопку \1\"Пролистать\"\1. Чтобы пометить диск как защищенный от записи или разрешенный для записи, установите или снимите, соответственно, флажок в пункте \1\"Защита записи\"\1 напротив соответствующего диска. Если один файл образа диска подключен к нескольким дисководам, то достаточно установить (снять) флажок напротив только одного из дисководов, к которым он подключен. Все изменения вступят в силу сразу после возврата в эмуляцию ZX-Spectrum.";
char TxtThanks[]="Особая благодарность:\nАлексею Емельянову (AvE), Андрею Замесову,\nСергею Юрину, Александру Микляеву, а также\nвсем, кто выразил свои пожелания и замечания.\n\nE-mail:   nshal@usa.net\nFidoNet:  2:5020/378.40";
char TxtROM4[]="Файл ROM \00148";
char TxtROM2[]="Файл ROM \001128";
char TxtROMT[]="Файл ROM \1TR-DOS";
char TxtROMU[]="Файл ROM \1пользователя";
char TxtDskA[]="Диск \1A";
char TxtDskB[]="Диск \1B";
char TxtDskC[]="Диск \1C";
char TxtDskD[]="Диск \1D";
char TxtDskWrA[]="Диск A";
char TxtDskWrB[]="Диск B";
char TxtDskWrC[]="Диск C";
char TxtDskWrD[]="Диск D";
char TxtDskCpy[]="\1Имя файла для диска";
char TxtDrv[]="Дис\1ковод для утилит\nДисковод A\nДисковод B";
char TxtBr[]="Пролистать";
char TxtDskPath[]="Путь для \1дисков";
char TxtROMPath[]="Путь для \1ROM";
char TxtAddPath[]="Путь для \1модулей";
char TxtSound[]="\1Звук";
char TxtSndC[]="\1Звуковая карта\nНет карты\nAd Lib\nSound Blaster";
char TxtSndDg[]="\1Цифровой звук";
char TxtSBAdr[]="\1Адрес SB\n210\n220\n230\n240\n250\n260\n280";
char TxtAdLibWS[]="Ци\1клы ожидания Ad Lib";
char TxtSBVol[]="\1Громкость";
char TxtEnvMul[]="Оги\1бающая\nx1\nx2\nx4\nx8\nx16\nx32\nx64\nx128\nx256\nx512";
char TxtFormat[]="Фо\1рматирование";
char TxtInput[]="\1Управление";
char TxtMTyp[]="Ти\1п мыши\nНет мыши\nKempston";
char TxtMRatX[]="Скорость мыши по \1X";
char TxtMRatY[]="Скорость мыши по \1Y";
char TxtMXChg[]="Смена \1кнопок мыши";
char TxtMLim[]="О\1граничение перемещения мыши";
char TxtSpd[]="С\1корость";
char TxtSpdCfg[]="\1Скорость\nНормальная\nМаксимальная\nУскоренная\nЗамедленная\nВыборочная";
char TxtSpdPar[]="Параметры:\nОсновной  Пиксели   Атрибуты";
char TxtSpdMaxTR[]="\1Максимальная скорость в TR-DOS";
char TxtAdv[]="\1Дополнительно";
char TxtFilToDsk[]="\1Файл на диск";
char TxtDskToFil[]="\1Диск в файл";
char TxtAutSave[]="\1Автосохранение конфигурации";
char TxtExitConf[]="\1Подтверждение выхода";
char TxtDblKeyKemp[]="\1Двойные клавиши и Kempston джойстик";
char TxtResT[]="Р\1ежим рестарта\n128K\n48K\nTR-DOS";
char TxtIntS[]="\1Источник прерываний\nТаймер\nПрерывание VGA\nОбратный ход луча";
char TxtVerR[]="\1Частота кадров\n50 Hz\n55 Hz\n60 Hz\n75 Hz";
char TxtReady[]="Постоянная \1готовность диска";
char TxtReadIndTr[]="Чтение \1номера дорожки";
char TxtGrayMode[]="\1Монохромный режим";
char TxtIntLen[]="Д\1лительность прерывания";
char TxtFrInt[]="Частота п\1рерываний";
char TxtFormLen[]="Длина данных \1форматирования";
char TxtVidIRQ[]="\1IRQ VGA\n9\n10\n11\n12";
char TxtAddition[]="\1Модули";
char TxtAdd[]="\1Добавить";
char TxtRemove[]="\1Убрать";
char TxtErLineMuch[]="Слишком длинная строка: ";
char TxtErUnknownVal[]="Недопустимое значение опции: ";
char TxtErValSmall[]="Слишком маленькое значение: ";
char TxtErValLarge[]="Слишком большое значение: ";
char TxtErUnknownOpt[]="Недопустимая опция: ";
char TxtErValMuch[]="Слишком длинное значение опции: ";
char TxtErNoAdd[]="Нет модуля для строки: ";
char TxtErSaveCfg[]="Ошибка при сохранении конфигурации";
char TxtErVGA[]="Программе необходима VGA-совместимая видеокарта";
char TxtErAllocMem[]="Ошибка выделения памяти";
char TxtErFreeMem[]="Ошибка освобождения памяти";

#else

char ButtOK[]="\1OK";
char PrMes[]="ZX-Spectrum Emulator  " Ver "\n(c) 1995-1999 Nikolay Shalaev\n";
char ProgName[]="ZX-Spectrum Emulator";
char ButtStart[]="\1Start";
char TxtConfig[]="\1Configuration";
char TxtCfg[]="\1Configure";
char TxtUtil[]="\1Utility";
char TxtUtilDiskToFile[]="Copy disk to file";
char TxtUtilFileToDisk[]="Restore disk from file";
char TxtCont[]="\1Continue";
char TxtInfo[]="\1Information";
char TxtExit[]="E\1xit";
char TxtPath[]="\1Paths";
char TxtFileCh[]="Change file";
char TxtFileName[]="Filename";
char TxtDisks[]="Disks";
char TxtSave[]="\1Save";
char TxtOpSuc[]="Operation completed successfully";////?
char ButtCanc[]="Ca\1ncel";
char ButtYes[]="\1Yes";
char ButtNo[]="\1No";
char TxtWrPr[]="Write protect";
char TxtSure[]="Are you sure?";
char TxtErPth[]="Path not found: ";
char TxtErDisk[]="Disk Error";
char TxtErNoFile[]="No file: ";
char TxtErFOpen[]="Can't open file: ";
char TxtErFRead[]="Can't read file: ";
char TxtErFSave[]="Can't write file: ";
char TxtErAdLib[]="Error: Ad Lib initialization";///?
char TxtErSndBl[]="Error: Sound Blaster initialization";
char TxtErNotCorF[]="Not correct file: ";
char TxtErBadVer[]="Not supported version of file: ";
char TxtErNoMem[]="Not enough memory for loading: ";
char TxtRetry[]="\1Retry";
char TxtAbort[]="\1Abort";
char TxtIgnore[]="\1Ignore";
char TxtJoyK[]="\1Kempston Joystick";
char TxtJoyS[]="\1Sinclair Joystick";
char TxtHlp[]="Help";
char TxtHlpSw[]="\nUsage: SPECTRUM [-<Option>...] [<Disk A> <Disk B>...]\nExample: SPECTRUM -S DISK.TRD\nOptions:\n H - help\n S - quick start";
char TxtHlpMain[]="";//////
char TxtHlpCfg[]="";///////
char TxtHlpUtil[]="";//////
char TxtHlpROM[]="";///////
char TxtHlpSound[]="";/////
char TxtHlpInput[]="";/////
char TxtHlpSpeed[]="";/////
char TxtHlpAdv[]="";///////
char TxtHlpDisks[]="";/////
char TxtHlpPath[]="";//////
char TxtThanks[]="Special Thanks to Alexey Emelyanov (AvE),\nAndrey Zamesov, Sergey Yurin, Alexander Miklyaev\nand everybody who sent his comments and suggestions about the emulator.\n\nE-mail:   nshal@usa.net\nFidoNet:  2:5020/378.40";////?
char TxtROM4[]="\00148 ROM";
char TxtROM2[]="\001128 ROM";
char TxtROMT[]="\1TR-DOS ROM";
char TxtROMU[]="\1User ROM";
char TxtDskA[]="Disk \1A";
char TxtDskB[]="Disk \1B";
char TxtDskC[]="Disk \1C";
char TxtDskD[]="Disk \1D";
char TxtDskWrA[]="Disk A";
char TxtDskWrB[]="Disk B";
char TxtDskWrC[]="Disk C";
char TxtDskWrD[]="Disk D";
char TxtDskCpy[]="File\1name for disk";
char TxtDrv[]="Dri\1ve for utility\nDrive A\nDrive B";
char TxtBr[]="Browse";
char TxtDskPath[]="Path for \1disks";
char TxtROMPath[]="Path for \1ROM";
char TxtAddPath[]="Path for \1modules";
char TxtSound[]="S\1ound";
char TxtSndC[]="Sound \1card\nNone\nAd Lib\nSound Blaster";
char TxtSndDg[]="\1Digital sound";
char TxtSBAdr[]="SB \1adress\n210\n220\n230\n240\n250\n260\n280";
char TxtAdLibWS[]="Ad Lib \1wait cycles";
char TxtSBVol[]="\1Volume";
char TxtEnvMul[]="\1Envelope\nx1\nx2\nx4\nx8\nx16\nx32\nx64\nx128\nx256\nx512";
char TxtFormat[]="Fo\1rmat";
char TxtInput[]="Con\1trol";
char TxtMTyp[]="Mouse \1type\nNo mouse\nKempston";
char TxtMRatX[]="Mouse Rate \1X";
char TxtMRatY[]="Mouse Rate \1Y";////
char TxtMXChg[]="Mouse \1buttons xchange";
char TxtMLim[]="Mouse move \1limit";
char TxtSpd[]="Sp\1eed";
char TxtSpdCfg[]="\1Speed\nNormal\nMaximal\nAccelerated\nReduced\nUser";
char TxtSpdPar[]="Parameters:\nMain      Pixel     Attributes";
char TxtSpdMaxTR[]="Ma\1ximal speed in TR-DOS";
char TxtAdv[]="Ad\1vanced";
char TxtFilToDsk[]="\1File to Disk";
char TxtDskToFil[]="\1Disk to File";
char TxtAutSave[]="\1Autosave Config";
char TxtDblKeyKemp[]="\1Double key and Kempston joystick";
char TxtExitConf[]="Exit \1confirm";
char TxtResT[]="Restart \1mode\n128K\n48K\nTR-DOS";
char TxtVidIRQ[]="VGA \1IRQ\n9\n10\n11\n12";
char TxtIntS[]="Int \1source\nTimer\nVGA interrupt\nVertical retrace";
char TxtVerR[]="\1Vertical rate\n50 Hz\n55 Hz\n60 Hz\n75 Hz";
char TxtReady[]="Constant Disk R\1eady";////?
char TxtReadIndTr[]="Read \1Track Number";
char TxtGrayMode[]="\1Gray mode";
char TxtIntLen[]="Interrupt \1Lenght";
char TxtFrInt[]="I\1nterrupt Frequency";
char TxtFormLen[]="\1Format Data Lenght";///?
char TxtAddition[]="\1Modules";
char TxtAdd[]="\1Add";
char TxtRemove[]="\1Remove";
char TxtErLineMuch[]="Configure line is too long: ";
char TxtErUnknownVal[]="Unknown value options: ";
char TxtErValSmall[]="Value is too small: ";
char TxtErValLarge[]="Value is too large: ";
char TxtErUnknownOpt[]="Unknown option: ";
char TxtErValMuch[]="Line size is too long: ";
char TxtErNoAdd[]="The module for line is absent: ";
char TxtErSaveCfg[]="Can't save configuration";
char TxtErVGA[]="Program requires VGA-compatible videocard";
char TxtErAllocMem[]="Allocating memory block error";
char TxtErFreeMem[]="Free memory block error";

#endif
