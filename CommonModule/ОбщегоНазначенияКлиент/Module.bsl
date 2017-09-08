﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Клиентские процедуры и функции общего назначения:
// - для работы со списками в формах;
// - для работы с журналом регистрации;
// - для обработки действий пользователя в процессе редактирования
//   многострочного текста, например комментария в документах;
// - прочее.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Функции работы со списками в формах

// Проверяет, что в параметре команды Параметр передан объект ожидаемого типа ОжидаемыйТип.
// В противном случае, выдает стандартное сообщение и возвращает Ложь.
// Такая ситуация возможна, например, если в списке выделена строка группировки.
//
// Для использования в командах, работающих с элементами динамических списков в формах.
// Пример использования:
// 
//   Если НЕ ПроверитьТипПараметраКоманды(Элементы.Список.ВыделенныеСтроки, 
//      Тип("ЗадачаСсылка.ЗадачаИсполнителя")) Тогда
//      Возврат;
//   КонецЕсли;
//   ...
// 
// Параметры:
//  Параметр     - Массив или ссылочный тип - параметр команды.
//  ОжидаемыйТип - Тип                      - ожидаемый тип параметра.
//
// Возвращаемое значение:
//  Булево - Истина, если параметр ожидаемого типа.
//
Функция ПроверитьТипПараметраКоманды(Знач Параметр, Знач ОжидаемыйТип) Экспорт
	
	Если Параметр = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	
	Если ТипЗнч(Параметр) = Тип("Массив") Тогда
		// Если в массиве один элемент и он неправильного типа...
		Результат = НЕ (Параметр.Количество() = 1 И ТипЗнч(Параметр[0]) <> ОжидаемыйТип);
	Иначе
		Результат = ТипЗнч(Параметр) = ОжидаемыйТип;
	КонецЕсли;
	
	Если НЕ Результат Тогда
		Предупреждение(НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры общего назначения

// Возвращает текущую дату, приведенную к часовому поясу сеанса.
//
// Функция возвращает время, близкое к результату функции ТекущаяДатаСеанса() в серверном контексте.
// Погрешность обусловлена временем выполнения серверного вызова.
// Предназначена для использования вместо функции ТекущаяДата().
//
Функция ДатаСеанса() Экспорт
	Возврат ТекущаяДата() + СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПоправкаКВремениСеанса;
КонецФункции

// Предлагает пользователю установить расширение работы с файлами в веб-клиенте.
// При этом инициализирует параметр сеанса ПредлагатьУстановкуРасширенияРаботыСФайлами.
//
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
// Например:
//
//    ПредложитьУстановкуРасширенияРаботыСФайлами("Для печати документа необходимо установить расширение работы с файлами.");
//    // далее располагается код печати документа
//    //...
//
// Параметры
//  Сообщение  - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//   
// Возвращаемое значение:
//  Строка - возможные значения:
//           Подключено                - расширение подключено
//           НеПодключено              - пользователь отказался от подключения 
//           НеподдерживаемыйВебКлиент - расширение не может быть подключено, так как не поддерживается в Веб-клиенте
//   
Функция ПредложитьУстановкуРасширенияРаботыСФайлами(ТекстПредложения = Неопределено) Экспорт
	
#Если ВебКлиент Тогда
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	Если РасширениеПодключено Тогда
		Возврат "Подключено"; // если расширение и так уже есть, незачем про него спрашивать
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентБезПоддержкиРасширенияРаботыСФайлами() Тогда
		Возврат "НеподдерживаемыйВебКлиент";
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	ПервоеОбращениеЗаСеанс = Ложь;
	
	Если ПредлагатьУстановкуРасширенияРаботыСФайлами = Неопределено Тогда
		
		ПервоеОбращениеЗаСеанс = Истина;
		ПредлагатьУстановкуРасширенияРаботыСФайлами = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента);
		Если ПредлагатьУстановкуРасширенияРаботыСФайлами = Неопределено Тогда
			ПредлагатьУстановкуРасширенияРаботыСФайлами = Истина;
			ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
				"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента,
				ПредлагатьУстановкуРасширенияРаботыСФайлами);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПредлагатьУстановкуРасширенияРаботыСФайлами = Ложь Тогда
		Возврат ?(РасширениеПодключено, "Подключено", "НеПодключено");
	КонецЕсли;
	
	Если ПервоеОбращениеЗаСеанс Тогда
		ПараметрыФормы = Новый Структура("Сообщение", ТекстПредложения);
		КодВозврата = ОткрытьФормуМодально("ОбщаяФорма.ВопросОбУстановкеРасширенияРаботыСФайлами", ПараметрыФормы);
		Если КодВозврата = Неопределено Тогда
			КодВозврата = Истина;
		КонецЕсли;
		
		ПредлагатьУстановкуРасширенияРаботыСФайлами = КодВозврата;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента,
			ПредлагатьУстановкуРасширенияРаботыСФайлами);
	КонецЕсли;
	Возврат ?(ПодключитьРасширениеРаботыСФайлами(), "Подключено", "НеПодключено");
	
#Иначе
	Возврат "Подключено";
#КонецЕсли
	
КонецФункции

// Предлагает пользователю подключить расширение работы с файлами в веб-клиенте,
// и в случае отказа выдает предупреждение о невозможности продолжения операции.
//
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами
// только при подключенном расширении.
// Например:
//
//    Если Не РасширениеРаботыСФайламиПодключено("Для печати документа необходимо установить расширение работы с файлами.") Тогда
//      Возврат;
//    КонецЕсли; 
//    // далее располагается код печати документа
//    //...
//
// Параметры
//  ТекстПредложения    - Строка - текст с предложением подключить расширение работы с файлами. 
//                                 Если не указан, то выводится текст по умолчанию.
//  ТекстПредупреждения - Строка - текст предупреждения о невозможности продолжения операции. 
//                                 Если не указан, то выводится текст по умолчанию.
//
// Возвращаемое значение:
//  Булево - Истина, если расширение подключено.
//   
Функция РасширениеРаботыСФайламиПодключено(ТекстПредложения = Неопределено, ТекстПредупреждения = Неопределено) Экспорт
	
	Результат = ПредложитьУстановкуРасширенияРаботыСФайлами(ТекстПредложения);
	ТекстСообщения = "";
	Если Результат = "НеПодключено" Тогда
		Если ТекстПредупреждения <> Неопределено Тогда
			ТекстСообщения = ТекстПредупреждения;
		Иначе
			ТекстСообщения = НСтр("ru = 'Действие недоступно, так как не подключено расширение работы с файлами в Веб-клиенте.'")
		КонецЕсли;
	ИначеЕсли Результат = "НеподдерживаемыйВебКлиент" Тогда
		ТекстСообщения = НСтр("ru = 'Действие недоступно в используемом Веб-клиенте, так как для него не может быть подключено расширение работы с файлами.'");
	КонецЕсли;
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		Предупреждение(ТекстСообщения);
	КонецЕсли;
	Возврат Результат = "Подключено";
	
КонецФункции

// Выполняет регистрацию компоненты "comcntr.dll" для текущей версии платформы.
// В случае успешной регистрации, предлагает пользователю перезапустить клиентский сеанс 
// для того чтобы регистрация вступила в силу.
//
// Вызывается перед клиентским кодом, который использует менеджер COM-соединений (V82.COMConnector)
// и инициируется интерактивными действиями пользователя. Например:
// 
// ЗарегистрироватьCOMСоединитель();
//   // далее идет код, использующий менеджер COM-соединений (V82.COMConnector)
//   // ...
//
Процедура ЗарегистрироватьCOMСоединитель() Экспорт
	#Если НЕ ВебКлиент Тогда
	ТекстКоманды = "";
	Попытка
		ИмяБатФайла		= ПолучитьИмяВременногоФайла("bat");
		ИмяФайлаЛога	= ПолучитьИмяВременногоФайла("log");
		БатФайл = Новый ЗаписьТекста(ИмяБатФайла);
		ТекстКоманды = "echo off
				|""regsvr32.exe"" /n /i:user /s ""%1comcntr.dll""
				| echo %2 >>""%3""";
		ТекстКоманды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстКоманды,КаталогПрограммы(),"%errorlevel%",ИмяФайлаЛога);
		БатФайл.ЗаписатьСтроку(ТекстКоманды);
		БатФайл.Закрыть();
	    Shell = Новый COMОбъект("WScript.Shell");
		Shell.Run(ИмяБатФайла, 0, Истина); // запуск бат-файла со спрятанным окном (0) и с ожиданием завершения (Истина)
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = НСтр("ru = 'Ошибка при регистрации компоненты comcntr.'") + Символы.ПС;
		ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Регистрация компоненты comcntr'"), "Ошибка", 
			ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
		Предупреждение(ТекстСообщения + НСтр("ru = 'Подробности см. в Журнале регистрации.'"));
		Возврат;
	КонецПопытки;
	
	Стр = "";
	Попытка
		УдалитьФайлы(ИмяБатФайла);
		ФайлЛога	= Новый ЧтениеТекста(ИмяФайлаЛога);
		Стр			= ФайлЛога.ПрочитатьСтроку();
		ФайлЛога.Закрыть();
		УдалитьФайлы(ИмяФайлаЛога);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = НСтр("ru = 'Ошибка при регистрации компоненты comcntr.'") + Символы.ПС;
		ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Регистрация компоненты comcntr'"), "Ошибка",
			ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
		Предупреждение(ТекстСообщения + НСтр("ru = 'Подробности см. в Журнале регистрации.'"));
		Возврат;
	КонецПопытки;
		
	Если СокрЛП(Стр) <> "0" Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка при регистрации компоненты comcntr.'") + Символы.ПС;
		ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Регистрация компоненты comcntr'"), "Ошибка",ТекстСообщения + 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Код ошибки regsvr32: %1.
				| (Код ошибки 5 означает, что недостаточно прав доступа. Выполните команду от имени пользователя с правами администратора на локальной машине.)
			    |
				|Текст команды: 
				|%2'"), Стр, ТекстКоманды));
		ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
		Предупреждение(ТекстСообщения + НСтр("ru = '
			|Подробности см. в Журнале регистрации.'"));
		Возврат;
	КонецЕсли;
	
	Ответ = Вопрос(НСтр("ru = 'Для завершения перерегистрации компоненты comcntr необходимо перезапустить сеанс 1С:Предприятия.
		|Перезапустить сейчас?'"), РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
		ЗавершитьРаботуСистемы(Истина, Истина);
	КонецЕсли;
	#КонецЕсли

КонецПроцедуры

// Процедура позволяет выбрать время из выпадающего списка.
// Параметры:
//  Форма - управляемая форма / форма - форма, на которой располагается элемент,
//                                      для которого будет выбираться время
//  ПолеВводаФормы -  ПолеФормы - элемент-владелец списка, у которого будет
//                                показан выпадающий список значений времен
//  ТекущееЗначение - Дата - значение, на которое будет спозиционирован выпадающий список
//  Интервал - число - интервал времени (в секундах), с которым необходимо заполнить список, по умолчанию час
//
Функция ВыбратьВремя(Форма, ПолеВводаФормы, Знач ТекущееЗначение, Интервал = 3600) Экспорт
	
	НачалоРабочегоДня      = '00010101000000';
	ОкончаниеРабочегоДня   = '00010101235959';
	
	СписокВремен = Новый СписокЗначений;
	НачалоРабочегоДня = НачалоЧаса(НачалоДня(ТекущееЗначение) +
		Час(НачалоРабочегоДня) * 3600 +
		Минута(НачалоРабочегоДня)*60);
	ОкончаниеРабочегоДня = КонецЧаса(НачалоДня(ТекущееЗначение) +
		Час(ОкончаниеРабочегоДня) * 3600 +
		Минута(ОкончаниеРабочегоДня)*60);
	
	ВремяСписка = НачалоРабочегоДня;
	
	Пока НачалоЧаса(ВремяСписка) <= НачалоЧаса(ОкончаниеРабочегоДня) Цикл
		
		Если НЕ ЗначениеЗаполнено(ВремяСписка) Тогда
			ПредставлениеВремени = "00:00";
		Иначе
			ПредставлениеВремени = Формат(ВремяСписка,"ДФ=ЧЧ:мм");
		КонецЕсли;
		
		СписокВремен.Добавить(ВремяСписка, ПредставлениеВремени);
		
		ВремяСписка = ВремяСписка + Интервал;
		
	КонецЦикла;
	
	НачальноеЗначение = СписокВремен.НайтиПоЗначению(ТекущееЗначение);
	
	Если НачальноеЗначение = Неопределено Тогда
		ВыбранноеВремя = Форма.ВыбратьИзСписка(СписокВремен, ПолеВводаФормы);
	Иначе
		ВыбранноеВремя = Форма.ВыбратьИзСписка(СписокВремен, ПолеВводаФормы, НачальноеЗначение);
	КонецЕсли;
	
	Если ВыбранноеВремя = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ВыбранноеВремя.Значение;
	
КонецФункции

// Возвращает Истина, если клиентское приложение подключено к базе через веб-сервер.
//
Функция КлиентПодключенЧерезВебСервер() Экспорт
	
	Возврат Найти(Врег(СтрокаСоединенияИнформационнойБазы()), "WS=") = 1;
	
КонецФункции

// Задает вопрос о продолжении действия, влекущего к потере изменений.
//
// Параметры:
//  Отказ               - Булево - возвращаемый параметр, признак отказа от выполняемого действия;
//  Модифицированность  - Булево - признак модифицированности формы, из которой вызывается данная процедура;
//  ДействиеВыбрано     - Булево - признак выбора пользователем действия, приводящего к закрытию формы;
//  ТекстПредупреждения - Строка - текст диалога с пользователем.
//
Процедура ЗапроситьПодтверждениеЗакрытияФормы(Отказ, Модифицированность = Истина, ДействиеВыбрано = Ложь, ТекстПредупреждения = "") Экспорт
	
	Если ДействиеВыбрано = Истина Или Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = ?(ПустаяСтрока(ТекстПредупреждения), 
		НСтр("ru = 'Данные были изменены, внесенные изменения будут отменены.
		           |Отменить и закрыть?'"),
		ТекстПредупреждения);
	Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, 
		НСтр("ru = 'Отмена изменений'"));
		
	Отказ = (Результат = КодВозвратаДиалога.Нет);	
	
КонецПроцедуры

// Функция получает цвет стиля по имени элемента стиля
//
// Параметры:
//	ИмяЦветаСтиля - строка с именем элемента
//
// Возвращаемое значение - цвет стиля
//
Функция ЦветСтиля(ИмяЦветаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияПовтИсп.ЦветСтиля(ИмяЦветаСтиля);
	
КонецФункции

// Функция получает шрифт стиля по имени элемента стиля
//
// Параметры:
//	ИмяШрифтаСтиля - строка с именем элемента
//
// Возвращаемое значение - шрифт стиля
//
Функция ШрифтСтиля(ИмяШрифтаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияПовтИсп.ШрифтСтиля(ИмяШрифтаСтиля);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с журналом регистрации

// Записывает очередное сообщение в глобальный массив сообщений.
//
//  Параметры : 
//   ИмяСобытия          - Строка - имя события для журнала регистрации;
//   ПредставлениеУровня - Строка - описание уровня события, по нему будет определен уровень события при записи на сервере;
//   ОбъектМетаданных    - ОбъектМетаданных - подробнее см. синтакс-помощник по "ЗаписьЖурналаРегистрации";
//   Данные              - Произвольный - данные, с которыми связано событие (например, ссылки на объект);
//   Комментарий         - Строка - комментарий для события журнала;
//   ПредставлениеРежима - Строка - представление режима транзакции для данного события;
//   ДатаСобытия         - Дата - точная дата возникновения события, описанного в сообщении. Будет добавлена в начало комментария;
//   ЗаписатьСобытия     - Булево - признак вызова процедуры непосредственной записи накопленных сообщений после добавления.
//
Процедура ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия, ПредставлениеУровня = "Информация", 
	Комментарий = "", ДатаСобытия = "", ЗаписатьСобытия = Ложь) Экспорт
	
	// В случае необходимости выполним инициализацию глобального списка сообщений для журнала регистрации.
	Если СообщенияДляЖурналаРегистрации = Неопределено Тогда
		СообщенияДляЖурналаРегистрации = Новый СписокЗначений;
	КонецЕсли;
	
	СтруктураСообщения = Новый Структура("ИмяСобытия, ПредставлениеУровня, Комментарий, ДатаСобытия", 
		ИмяСобытия, ПредставлениеУровня, Комментарий, ДатаСобытия);
		
	СообщенияДляЖурналаРегистрации.Добавить(СтруктураСообщения);
	
	Если ЗаписатьСобытия Тогда
		ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	КонецЕсли;
		
КонецПроцедуры

// Проверяет текущий вариант использования журнала регистрации.
// Если регистрация изменений отключена - то предлагает полностью включить его.
//
// Параметры: 
//  СписокПроверок - СписокЗначений - список строковых представлений режимов журнала регистрации, которые необходимо проверить на включение.
//  СпрашиватьОРегистрации - Булево - признак, отвечающий за вопрос о включении журнала в необходимых режимах.
//  СообщениеОНеобходимостиВключенияЖурнала - Строка - сообщение, которое будет выведено пользователю в случае, когда проверка не прошла, и надо включить журнале регистрации.
//
Процедура ПроверитьВключениеЖурналаРегистрации(СписокПроверок = Неопределено, 
	СпрашиватьОРегистрации = Истина, СообщениеОНеобходимостиВключенияЖурнала = "") Экспорт
	
	// регистрация данных видов событий уже включена
	Если ОбщегоНазначения.ПроверитьВключениеЖурналаРегистрации(СписокПроверок) Тогда
		Возврат;
	КонецЕсли;
	
	Если СпрашиватьОРегистрации Тогда 
		
		Если Не ПустаяСтрока(СообщениеОНеобходимостиВключенияЖурнала) Тогда // если было передано произвольное сообщение, тогда выведем его
			ТекстВопроса = СообщениеОНеобходимостиВключенияЖурнала;
		Иначе	
			
			Если СписокПроверок = Неопределено Тогда
				ТекстВопроса = НСтр("ru = 'Для продолжения рекомендуется включить использование Журнала регистрации. 
					|В противном случае, запись событий в Журнал регистрации не будет произведена. 
					|Включить сейчас?'");
			Иначе
				ТекстВопроса = НСтр("ru = 'Для продолжения рекомендуется включить регистрацию событий %1 в Журнале регистрации. 
					|В противном случае, записи событий в Журнал регистрации будут неполными. 
					|Включить сейчас?'");
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, СписокПроверок);
			КонецЕсли;
		КонецЕсли;
	
		Режим = РежимДиалогаВопрос.ДаНет;
		Умолчание = КодВозвратаДиалога.Да;
		Заголовок = НСтр("ru = 'Журнал регистрации'");
		КодВозврата = Вопрос(ТекстВопроса, Режим, , Умолчание, Заголовок);
	Иначе
		КодВозврата = КодВозвратаДиалога.Да;
	КонецЕсли;
	
	
	Если КодВозврата = КодВозвратаДиалога.Да Тогда
		Попытка 
			ОбщегоНазначения.ВключитьИспользованиеЖурналаРегистрации(СписокПроверок);
			Текст = НСтр("ru = 'Настройка изменена'");
			Пояснение = НСтр("ru = 'Регистрация событий в журнале регистрации обновлена'");
			ПоказатьОповещениеПользователя(Текст,,Пояснение);
		Исключение

			ИмяСобытия = НСтр("ru = 'Настройка журнала регистрации'");
			ПредставлениеУровня = "Ошибка";
			Комментарий = НСтр("ru = 'Невозможно установить монопольный доступ. Настройка журнала регистрации не изменена'");
			ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия, ПредставлениеУровня, Комментарий,, Истина);
			
			ОткрытьФорму("ОбщаяФорма.ВключениеЖурналаРегистрации",Новый Структура("СписокПроверок",СписокПроверок)); 
			
		КонецПопытки;

	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции для обработки действий пользователя в процессе редактирования
// многострочного текста, например комментария в документах.

// Открывает форму редактирования произвольного многострочного текста модально.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать;
//  РезультатРедактирования - Строка - в этот параметр будет помещен результат редактирования;
//  Модифицированность      - Строка - флаг модифицированности формы;
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//
Процедура ОткрытьФормуРедактированияМногострочногоТекста(Знач МногострочныйТекст, РезультатРедактирования, Модифицированность = Ложь, 
		Знач Заголовок = Неопределено) Экспорт
	
	Если Заголовок = Неопределено Тогда
		ТекстВведен = ВвестиСтроку(МногострочныйТекст,,, Истина);
	Иначе
		ТекстВведен = ВвестиСтроку(МногострочныйТекст, Заголовок,, Истина);
	КонецЕсли;
	
	Если Не ТекстВведен Тогда
		Возврат;
	КонецЕсли;
		
	РезультатРедактирования = МногострочныйТекст;
	Если Не Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму редактирования многострочного комментария модально.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать
//  РезультатРедактирования - Строка - переменная, в которую будет помещен результат редактирования
//  Модифицированность       - Строка - флаг модифицированности формы
//
// Пример использования:
//  ОткрытьФормуРедактированияКомментария(Элемент.ТекстРедактирования, Объект.Комментарий, Модифицированность);
//
Процедура ОткрытьФормуРедактированияКомментария(Знач МногострочныйТекст, РезультатРедактирования,
	Модифицированность = Ложь) Экспорт
	
	ОткрытьФормуРедактированияМногострочногоТекста(МногострочныйТекст, РезультатРедактирования, Модифицированность, 
		НСтр("ru='Комментарий'"));
	
КонецПроцедуры
