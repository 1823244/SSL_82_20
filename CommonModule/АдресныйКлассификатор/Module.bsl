﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Адресный классификатор".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает версию адресных объектов, записанную при последнем обновлении
// Если записи об адресном объекте нет - возвращается дата 01.09.2008
// 
// Возвращаемое значение
// 	Массив соответствий: ключ - номер адресного объекта, значение - дата выпуска версии
//
Функция ПолучитьВерсииАдресныхОбъектов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустаяДата", '00000000');
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АдресныйКлассификатор.КодАдресногоОбъектаВКоде КАК АдресныйОбъект
	|ИЗ
	|	РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
	|
	|СГРУППИРОВАТЬ ПО
	|	АдресныйКлассификатор.КодАдресногоОбъектаВКоде
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(АдресныйКлассификатор.КодАдресногоОбъектаВКоде) <> 1
	|
	|УПОРЯДОЧИТЬ ПО
	|	АдресныйОбъект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Версии.АдресныйОбъект КАК АдресныйОбъект,
	|	Версии.ДатаВыпускаВерсии КАК ДатаВыпускаВерсии
	|ИЗ
	|	РегистрСведений.ВерсииОбъектовАдресногоКлассификатора КАК Версии";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	АдресныеОбъекты     = РезультатЗапроса[0].Выгрузить().ВыгрузитьКолонку("АдресныйОбъект");
	УстановленныеВерсии = РезультатЗапроса[1].Выгрузить();
	
	Результат = Новый СписокЗначений;
	
	Для каждого АдресныйОбъект Из АдресныеОбъекты Цикл
		ДобавитьВерсиюВСписок(Формат(АдресныйОбъект, "ЧЦ=2; ЧВН=; ЧГ=0"), УстановленныеВерсии, Результат);
	КонецЦикла;
	
	Если Результат.Количество() > 0 Тогда
		ДобавитьВерсиюВСписок("AL", УстановленныеВерсии, Результат);
		ДобавитьВерсиюВСписок("SO", УстановленныеВерсии, Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Процедура для загрузки данных в КЛАДР
//
// Параметры:
// 	КодАдресногоОбъекта- Строка - код адресного объекта в формате NN
// 	ПутьКДаннымНаСервере - Строка - путь к каталогу на сервере, в котором хранятся файлы кладр
// 	ЗагрузкаСВеб - Булево - если Истина, данные загружаются с веб сервера 1С
//
Процедура ЗагрузитьКлассификаторПоАдресномуОбъекту(знач КодАдресногоОбъекта,
                                                   ПутьКДаннымНаСервере,
                                                   ЗагрузкаСВеб) Экспорт
	
	КодАдресногоОбъекта = Лев(КодАдресногоОбъекта, 2);
	
	АльтернативныеНазвания = Новый ТаблицаЗначений;
	АльтернативныеНазвания.Колонки.Добавить("Код");
	АльтернативныеНазвания.Колонки.Добавить("Наименование");
	АльтернативныеНазвания.Колонки.Добавить("Сокращение");
	АльтернативныеНазвания.Колонки.Добавить("Индекс");
	
	АдресныеСведения = Новый ТаблицаЗначений;
	АдресныеСведения.Колонки.Добавить("Код");
	АдресныеСведения.Колонки.Добавить("КодАдресногоОбъектаВКоде");
	АдресныеСведения.Колонки.Добавить("Наименование");
	АдресныеСведения.Колонки.Добавить("АльтернативныеНазвания");
	АдресныеСведения.Колонки.Добавить("Сокращение");
	АдресныеСведения.Колонки.Добавить("Индекс");
	АдресныеСведения.Колонки.Добавить("ТипАдресногоЭлемента");
	АдресныеСведения.Колонки.Добавить("КодРайонаВКоде");
	АдресныеСведения.Колонки.Добавить("КодГородаВКоде");
	АдресныеСведения.Колонки.Добавить("КодНаселенногоПунктаВКоде");
	АдресныеСведения.Колонки.Добавить("КодУлицыВКоде");
	АдресныеСведения.Колонки.Добавить("ПризнакАктуальности");
	
	Постфикс						= ? (ЗагрузкаСВеб, КодАдресногоОбъекта, "");
	ИмяФайлаАльтернативныхНазваний	= ? (ЗагрузкаСВеб, "ALTN", "ALTNAMES");
	
	ЗагрузитьАдресныеСведения(КодАдресногоОбъекта,
	                          ПутьКДаннымНаСервере + "KLADR" + Постфикс,
	                          АдресныеСведения,
	                          АльтернативныеНазвания);
	
	ЗагрузитьАдресныеСведения(КодАдресногоОбъекта,
	                           ПутьКДаннымНаСервере + "STREET" + Постфикс,
	                           АдресныеСведения,
	                           АльтернативныеНазвания,
	                           5);
	
	ЗагрузитьАдресныеСведения(КодАдресногоОбъекта,
	                          ПутьКДаннымНаСервере + "DOMA" + Постфикс,
	                          АдресныеСведения,
	                          АльтернативныеНазвания,
	                          6);
	
	ЗаполнитьАльтернативныеНазвания(ПутьКДаннымНаСервере + ИмяФайлаАльтернативныхНазваний + Постфикс, 
									АдресныеСведения, 
									АльтернативныеНазвания);
	
	ЗаписатьКлассификатор(КодАдресногоОбъекта, АдресныеСведения);
	
КонецПроцедуры

// Процедура очищает адресные сведений по переданным адресным объектам.
// 
// Параметры
// МассивАдресныхОбъектов - Массив - каждый элемент - строка, номер
//                          адресного объекта в формате NN
//
Процедура УдалитьАдресныеСведения(знач МассивАдресныхОбъектов) Экспорт
	
	Для Каждого КодАдресногоОбъекта Из МассивАдресныхОбъектов Цикл
		НаборАдресныхСведений = РегистрыСведений.АдресныйКлассификатор.СоздатьНаборЗаписей();
		НаборАдресныхСведений.Отбор.КодАдресногоОбъектаВКоде.Использование = Истина;
		НаборАдресныхСведений.Отбор.КодАдресногоОбъектаВКоде.Значение = Число(КодАдресногоОбъекта);
		НаборАдресныхСведений.Записать();
		УстановитьВерсиюКлассификатора(КодАдресногоОбъекта);
	КонецЦикла;
	
КонецПроцедуры

// Функция возвращает число адресных объектов по которым заполнены адресные сведения
//
// Возвращаемое значение:
//	Число - число заполненных адресных объектов.
//
Функция ЧислоЗаполненныхАдресныхОбъектов() Экспорт
	
	ТекстЗапроса =  "ВЫБРАТЬ
					|	Истина
					|ИЗ
					|	РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
					|
					|СГРУППИРОВАТЬ ПО
					|	АдресныйКлассификатор.КодАдресногоОбъектаВКоде
					|
					|ИМЕЮЩИЕ
					|	КОЛИЧЕСТВО(АдресныйКлассификатор.КодАдресногоОбъектаВКоде) <> 1";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать().Количество();
	
КонецФункции

// Возвращает структуру, содержащую информацию по адресному объекту
// 
// Параметры
// 	КодАдресногоОбъекта - Строка - номер адресного объекта от 1 до 89 + 99 в формате NN
//
// Возвращаемое значение
// 	Структура, с ключами: КодАдресногоОбъекта, Наименование, Сокращение, Индекс.
//
Функция ИнформацияПоАдресномуОбъекту(КодАдресногоОбъекта) Экспорт
	
	КлассификаторАдресныхОбъектовXML = РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("КлассификаторАдресныхОбъектовРоссии").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторАдресныхОбъектовXML).Данные;
	
	Результат = Новый Структура("КодАдресногоОбъекта, Наименование, Сокращение, Индекс");
	
	Если КодАдресногоОбъекта = "AL" Тогда
		// 
		Результат.КодАдресногоОбъекта = "AL";
		Результат.Наименование        = НСтр("ru = 'Альтернативные названия'");
		Результат.Сокращение          = "";
		Результат.Индекс              = "";
		//
	ИначеЕсли КодАдресногоОбъекта = "SO" Тогда
		// 
		Результат.КодАдресногоОбъекта = "SO";
		Результат.Наименование        = НСтр("ru = 'Адресные сокращения'");
		Результат.Сокращение          = "";
		Результат.Индекс              = "";
	Иначе
		Для Каждого АдресныйОбъект Из КлассификаторТаблица Цикл
			Если Лев(АдресныйОбъект.Code, 2) = КодАдресногоОбъекта Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Результат.КодАдресногоОбъекта = АдресныйОбъект.Code;
		Результат.Наименование        = АдресныйОбъект.Name;
		Результат.Сокращение          = АдресныйОбъект.Socr;
		Результат.Индекс              = АдресныйОбъект.Index;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Первоначальное заполнение и обновление ИБ

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.0.1.1";
		Обработчик.Процедура = "АдресныйКлассификатор.ЗагрузитьАдресныеОбъектыПервогоУровня";
		
	КонецЕсли;
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.0.1.11";
	Обработчик.Процедура = "АдресныйКлассификатор.РазложитьАдресныеОбъектыПоЭлементам";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры	

// Загружает адресные объекты первого уровня по макету
//
Процедура ЗагрузитьАдресныеОбъектыПервогоУровня() Экспорт
	
	КлассификаторАдресныхОбъектовXML = РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("КлассификаторАдресныхОбъектовРоссии").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторАдресныхОбъектовXML).Данные;
	
	НаборЗаписей = РегистрыСведений.АдресныйКлассификатор.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ТипАдресногоЭлемента.Установить(1);
	
	Для Каждого АдресныйОбъект Из КлассификаторТаблица Цикл
		
		МенеджерЗаписи 						= НаборЗаписей.Добавить();
		МенеджерЗаписи.Код                  = АдресныйОбъект.Code;
		МенеджерЗаписи.ТипАдресногоЭлемента = 1;
		МенеджерЗаписи.Наименование         = АдресныйОбъект.Name;
		МенеджерЗаписи.Сокращение           = АдресныйОбъект.Socr;
		МенеджерЗаписи.Индекс               = АдресныйОбъект.Index;
		МенеджерЗаписи.КодАдресногоОбъектаВКоде      = Лев(АдресныйОбъект.Code,2);
		
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Раскладывает коды адресных объектов на регион, район, город, населенный пункт, город, улицу и признак актуальности
//
Процедура РазложитьАдресныеОбъектыПоЭлементам() Экспорт
	
	// Обходим все записи регистра АдресныйКлассификатор и добавляем неактуальные адреса в массив
	МассивНеактуальныхАдресов = Новый Массив;
	Выборка = РегистрыСведений.АдресныйКлассификатор.Выбрать(,"<Нет>");
    Пока Выборка.Следующий() Цикл
		СтруктураАдреса = РазобратьАдресныйОбъектПоЭлементам(Выборка.Код, Выборка.ТипАдресногоЭлемента);
		Если СтруктураАдреса.ПризнакАктуальности <> 0 Тогда
			СтруктураАдреса.Вставить("Код", Выборка.Код);
			СтруктураАдреса.Вставить("ТипАдресногоЭлемента", Выборка.ТипАдресногоЭлемента);
			МассивНеактуальныхАдресов.Добавить(СтруктураАдреса);
		КонецЕсли;
	КонецЦикла;                                     
	
	// Исправляем записи с неактуальными адресами	
	Для Каждого СтруктураАдреса Из МассивНеактуальныхАдресов Цикл
		// Читаем для изменения запись с неактуальным адресом
		МенеджерЗаписи = РегистрыСведений.АдресныйКлассификатор.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ТипАдресногоЭлемента = СтруктураАдреса.ТипАдресногоЭлемента;
		МенеджерЗаписи.Код = СтруктураАдреса.Код;
		МенеджерЗаписи.Прочитать();
        // Записываем запись с исправлением неактуального адреса
		МенеджерЗаписи.ТипАдресногоЭлемента = СтруктураАдреса.ТипАдресногоЭлемента;
		МенеджерЗаписи.Код = СтруктураАдреса.Код;
		МенеджерЗаписи.КодАдресногоОбъектаВКоде = СтруктураАдреса.КодАдресногоОбъектаВКоде;
		МенеджерЗаписи.КодРайонаВКоде = СтруктураАдреса.КодРайонаВКоде;
		МенеджерЗаписи.КодГородаВКоде = СтруктураАдреса.КодГородаВКоде;
		МенеджерЗаписи.КодНаселенногоПунктаВКоде = СтруктураАдреса.КодНаселенногоПунктаВКоде;
		МенеджерЗаписи.КодУлицыВКоде = СтруктураАдреса.КодУлицыВКоде;
		МенеджерЗаписи.ПризнакАктуальности = СтруктураАдреса.ПризнакАктуальности;
		МенеджерЗаписи.Записать();
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Блок сервисных функций, используются при загрузке адресного классификатора

// Загружает адресные сокращения в регистр АдресныеСокращения.
//
// Параметры:
//	ПутьКДаннымНаСервере - путь к каталогу в котором находится файл socrbase.dbf
//	
// Возвращаемое значение
//	Булево - истина - сведения успешно записаны
//          ложь - ошибка при подготовке записи сведений в регистр
//
Функция ЗагрузитьАдресныеСокращения(ПутьКДаннымНаСервере) Экспорт
	
	ФайлАдресныхСокращений = ПутьКДаннымНаСервере +  "SOCRBASE.DBF";
	
	ТаблицаАдресныеСокращения = Новый ТаблицаЗначений;
	ТаблицаАдресныеСокращения.Колонки.Добавить("Код");
	ТаблицаАдресныеСокращения.Колонки.Добавить("Уровень");
	ТаблицаАдресныеСокращения.Колонки.Добавить("Наименование");
	ТаблицаАдресныеСокращения.Колонки.Добавить("Сокращение");
	
	АдресныеСокращения = РегистрыСведений.АдресныеСокращения;
	
	НаборЗаписей = АдресныеСокращения.СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
	
	xB = Новый XBase(ФайлАдресныхСокращений);
	xB.Кодировка = КодировкаXBase.OEM;
	
	// Контроль уникальности кодов в файле классификатора
	Контроль = Новый Соответствие;
	ЕстьОшибки = Ложь;
	Если xB.Открыта() Тогда
		Пока Не xB.ВКонце() Цикл
			КодУникальности = Число(xB.level) * 10000 + Число(xB.kod_t_st);
			Если Контроль[КодУникальности] = НеОпределено Тогда
				Контроль[КодУникальности] = 0;
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Код           = xB.kod_t_st;
				НоваяЗапись.Уровень       = xB.level;
				НоваяЗапись.Наименование  = xB.socrname;
				НоваяЗапись.Сокращение    = xB.scname;
			Иначе
				ЕстьОшибки = Истина;
			КонецЕсли;
			xB.Следующая();
			
		КонецЦикла;
		xB.ЗакрытьФайл();
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Если ЕстьОшибки Тогда
		СтрокаОшибки = НСтр("ru = 'В файле адресного классификатора %1 есть ошибки уникальности кодов'");
		ПараметрыВСтроке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаОшибки, "socrbase.dbf");
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Адресный классификатор.Загрузка'"), 
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПараметрыВСтроке);
	КонецЕсли;
	НаборЗаписей.Записать();
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие служебные процедуры и функции

// Проверяет наличие обновлений адресного классификатора на веб сервере
// для тех объектов, которые ранее уже загружались.
//
// Возвращаемое значение
// 	Массив структур, в котором каждая структура имеет формат:
// 		ключ КодАдресногоОбъекта - строка - код адресного объекта
// 		ключ Наименование       - строка - наименование адресного объекта
// 		ключ Сокращение         - строка - сокращение адресного объекта
// 		ключ Индекс             - строка - индекс адресного объекта
// 		ключ ОбновлениеДоступно - Булево
//
Функция ПроверитьОбновлениеАдресныхОбъектовСервер() Экспорт
	
	Возврат АдресныйКлассификаторКлиентСервер.ПроверитьОбновлениеАдресныхОбъектов();
	
КонецФункции

// Процедура загружает из файлов КЛАДР в регистр сведений данные по адресному объекту.
//
// Параметры:
//	ПараметрыЗагрузки - Структура - параметры для загрузки.
//	АдресХранилища - Строка - адрес внутреннего хранилища.
//
Процедура ЗагрузкаАдресныхСведенийИзФайловКЛАДРВРегистрСведений(ПараметрыЗагрузки, АдресХранилища) Экспорт
	
	СтатусВыполнения = Истина;
	СообщениеПользователю = "";
	
	СтруктураВозврата = Новый Структура("СтатусВыполнения, СообщениеПользователю, ПутьКДанным, ПутьКДаннымНаСервере");
	
	Попытка
		
		Если ПараметрыЗагрузки.ИсточникДанныхДляЗагрузки = 1 Тогда
			Результат = АдресныйКлассификаторКлиентСервер.ПолучитьВерсииДоступныеНаСайте1С();
			Если НЕ Результат.Статус Тогда
				СтруктураВозврата.СтатусВыполнения = Ложь;
				ПоместитьВоВременноеХранилище(СтруктураВозврата, АдресХранилища);
				Возврат;
			КонецЕсли;
			ДоступныеВерсии = Результат.ДоступныеВерсии;
		Иначе
			ДоступныеВерсии = Новый Соответствие;
			Для Каждого АдресныйОбъект Из ПараметрыЗагрузки.АдресныеОбъекты Цикл
				ДоступныеВерсии.Вставить(АдресныйОбъект, ПараметрыЗагрузки.ВерсияЗагружаемогоКЛАДР);
			КонецЦикла;
		КонецЕсли;
		
		ВерсииХранимыхСведений = ПолучитьВерсииАдресныхОбъектов();
		ТекущиеВерсии = Новый Соответствие;
		Для каждого ЭлементСписка Из ВерсииХранимыхСведений Цикл
			ТекущиеВерсии.Вставить(ЭлементСписка.Представление, ЭлементСписка.Значение);
		КонецЦикла;
		НовыеВерсииАдресныхОбъектов = Новый Соответствие;
		
		Для Каждого АдресныйОбъект Из ПараметрыЗагрузки.АдресныеОбъекты Цикл
			
			Если АдресныйОбъект = "AL" Тогда
				// Альтернативные названия загружаются с регионом
				Продолжить;
			ИначеЕсли АдресныйОбъект = "SO" Тогда
				// Адресные сокращения загружаются отдельно (ниже)
				Продолжить;
			КонецЕсли;
			
			АдресныеСведения = ИнформацияПоАдресномуОбъекту(АдресныйОбъект);
			ТекущаяВерсия   = ?(ТекущиеВерсии[АдресныйОбъект]   = Неопределено, '00000000', ТекущиеВерсии[АдресныйОбъект]);
			ДоступнаяВерсия = ?(ДоступныеВерсии[АдресныйОбъект] = Неопределено, '00000000', ДоступныеВерсии[АдресныйОбъект]);
			Если ДоступнаяВерсия <= ТекущаяВерсия Тогда
				СообщениеПользователю = СообщениеПользователю + 
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Сведения по объекту: %1 %2 не загружены, так как
						           |текущая версия от %3, а загружаемая от %4.'"),
						АдресныеСведения.Наименование,
						АдресныеСведения.Сокращение,
						Формат(ТекущаяВерсия, "ДЛФ=D"),
						Формат(ДоступнаяВерсия, "ДЛФ=D"));
				Продолжить;
			КонецЕсли;
			
			НовыеВерсииАдресныхОбъектов.Вставить(АдресныйОбъект, ДоступнаяВерсия);
			
			ЗагрузитьКлассификаторПоАдресномуОбъекту(
					АдресныйОбъект,
					ПараметрыЗагрузки.ПутьКДаннымНаСервере,
					ПараметрыЗагрузки.ИсточникДанныхДляЗагрузки = 1);
			
		КонецЦикла;
		
		ТекущаяВерсия   = ?(ТекущиеВерсии["SO"]   = Неопределено, '00000000', ТекущиеВерсии["SO"]);
		ДоступнаяВерсия = ?(ДоступныеВерсии["SO"] = Неопределено, '00000000', ДоступныеВерсии["SO"]);
		Если ДоступнаяВерсия > ТекущаяВерсия Тогда
			ЗагрузитьАдресныеСокращения(ПараметрыЗагрузки.ПутьКДаннымНаСервере);
			НовыеВерсииАдресныхОбъектов.Вставить("SO", ДоступнаяВерсия);
		КонецЕсли;
		
		ОбновитьВерсииАдресныхСведений(НовыеВерсииАдресныхОбъектов);
		
	Исключение
		
		ТекстСообщенияОшибки = НСтр("ru = 'Ошибка при загрузке адресных сведений: '");
		СообщениеПользователю = ТекстСообщенияОшибки + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		СтруктураВозврата.СтатусВыполнения 		= Ложь;
		СтруктураВозврата.СообщениеПользователю = СообщениеПользователю;
		ПоместитьВоВременноеХранилище(СтруктураВозврата, АдресХранилища);
		Возврат;
		
	КонецПопытки;	
	
	СтруктураВозврата.СтатусВыполнения 		= СтатусВыполнения;
	СтруктураВозврата.СообщениеПользователю = СообщениеПользователю;
	ПоместитьВоВременноеХранилище(СтруктураВозврата, АдресХранилища);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с версиями сведений по адресным объектам

// Устанавливает версию адресного объекта в регистре
//
// Параметры:
//	НомерАО - строка - код адресного объекта в формате NN
//	Наименование - наименование адресного объекта
//	ВерсияСведенийПоАдресномуОбъекту - дата - версия адресного объекта
//
Процедура УстановитьВерсиюКлассификатора(знач НомерАО,
                                         знач Наименование = "",
                                         знач ВерсияСведенийПоАдресномуОбъекту = "") Экспорт
	
	МенеджерЗаписи = РегистрыСведений.ВерсииОбъектовАдресногоКлассификатора.СоздатьМенеджерЗаписи();
	
	Если ПустаяСтрока(ВерсияСведенийПоАдресномуОбъекту) Тогда
		МенеджерЗаписи.АдресныйОбъект = НомерАО;
		МенеджерЗаписи.Прочитать();
		МенеджерЗаписи.Удалить();
	Иначе
		МенеджерЗаписи.АдресныйОбъект = НомерАО;
		МенеджерЗаписи.ДатаВыпускаВерсии = ВерсияСведенийПоАдресномуОбъекту;
		МенеджерЗаписи.Наименование = Наименование;
		
		МенеджерЗаписи.Записать(Истина);
	КонецЕсли;
	
КонецПроцедуры

// Считывает с диска файл версий адресных объектов и возвращает
// версии сведений по адресным объектам
//
// Параметры:
//	ТекстXML - Строка - строка, содержащая текст XML.
//
Функция ПолучитьВерсииАдресныхСведений(знач ТекстXML) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстXML);
	
	ЧтениеXML.Прочитать();
	
	Результат = Новый Соответствие;
	
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если ЧтениеXML.ИмяАтрибута(0) = "code"
			 ИЛИ ЧтениеXML.ИмяАтрибута(0) = "name" Тогда
				ДатаВыпуска = ПолучитьАтрибут(ЧтениеXML, "date");
				Результат.Вставить(ВРег(ЧтениеXML.ЗначениеАтрибута(0)), ДатаВыпуска);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	Возврат Результат;
	
КонецФункции

// Сохраняет файл архива из двоичных данных на сервере по 
// переданному имени в переданном каталоге, и распаковывает его.
//
// Параметры:
// 	ДвоичныеДанные - ДвоичныеДанные -данные файла
// 	ИмяФайлаАрхива - строка - имя файла
// 	ПутьККаталогуНаСервере - путь к каталогу, в который требуется положить распакованный файл
//
Процедура СохранитьФайлНаСервереИРаспаковать(знач ДвоичныеДанные,
                                             ИмяФайлаАрхива,
                                             ПутьККаталогуНаСервере) Экспорт
	
	Если ПутьККаталогуНаСервере = Неопределено Тогда
		ПутьККаталогуНаСервере = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
		СоздатьКаталог(ПутьККаталогуНаСервере);
	КонецЕсли;
	
	ДвоичныеДанные.Записать(ПутьККаталогуНаСервере + ИмяФайлаАрхива);
	
	ЧтениеZIP = Новый ЧтениеZipФайла(ПутьККаталогуНаСервере + ИмяФайлаАрхива);
	ЧтениеZIP.ИзвлечьВсе(ПутьККаталогуНаСервере,
	                     РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	ЧтениеZIP.Закрыть();
	УдалитьФайлы(ПутьККаталогуНаСервере, ИмяФайлаАрхива);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Аутентификация на пользовательском сайте 1С

// Получает параметры аутентификации пользователя (логин и пароль) на пользовательском сайте 1с.
//
// Возвращаемое значение:
// 	Булево - Истина - параметры аутентификации заполнены
//           Ложь   - хотя бы один из параметров аутентификации не заполнен
//
Функция ПолучитьПараметрыАутентификации(КодПользователя, Пароль) Экспорт
	
	КодПользователя = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"АутентификацияНаПользовательскомСайте", 
		"КодПользователя", ""
	);
	
	Пароль = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"АутентификацияНаПользовательскомСайте",
		"Пароль", ""
	);
	
	Возврат НЕ ПустаяСтрока(КодПользователя) И НЕ ПустаяСтрока(Пароль);
	
КонецФункции

// Сохраняет код пользователя и пароль в системном хранилище настроек ИБ
//
// Параметры
// 	КодПользователя - Строка - код пользователя, или логин, для доступа к пользовательскому сайту 1с
// 	Пароль - Строка - пароль
//
Процедура СохранитьПараметрыАутентификации(КодПользователя, Пароль) Экспорт
	
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"АутентификацияНаПользовательскомСайте",
		"КодПользователя",
		КодПользователя
	);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"АутентификацияНаПользовательскомСайте",
		"Пароль",
		Пароль
	);
	
КонецПроцедуры

// Обновляет версии адресных сведений.
//
// Параметры:
//	НовыеВерсии - Соттветствие - новые версиию
//
Процедура ОбновитьВерсииАдресныхСведений(НовыеВерсии) Экспорт
	
	Для каждого ОписаниеВерсии Из НовыеВерсии Цикл
		АдресныеСведения = ИнформацияПоАдресномуОбъекту(ОписаниеВерсии.Ключ);
		УстановитьВерсиюКлассификатора(ОписаниеВерсии.Ключ,
		                               АдресныеСведения.Наименование + " " + АдресныеСведения.Сокращение,
		                               ОписаниеВерсии.Значение);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции

// Функция для заполнения данных с 2-го по 6-й уровень классификации:
// 2-й - районы (улусы) республик, краев, областей, автономных областей,
//       автономных округов, входящих в состав Российской Федерации.
// 3-й   города и поселки городского типа1 регионального и районного подчинения;
//       сельсоветы (сельские округа, сельские администрации, волости и т.п.).
// 4-й   города и поселки городского типа , подчиненные администрациям городов третьего уровня;
//       сельские населенные пункты
// 5-й   улицы городов, поселков городского типа и сельских населенных пунктов.
// 6-й   дома, расположенные в городах и поселках городского типа, являющихся объектами
//       третьего уровня , в т.ч. дома, непосредственно привязанные к городам и поселкам
//       городского типа
//
// Параметры:
// 	КодАдресногоОбъекта  - строка (2 символа) - строковое представление номера адресного объекта
// 	ПутьКДаннымНаСервере - Строка - путь к каталогу на сервере, в котором 
//                 хранятся файлы кладр. Путь заканчивается слешем (обратным или прямым)
// 	АдресныеСведения - ТаблицаЗначений - таблица, которая заполняется загружаемыми элементами
// 	АльтернативныеНазвания
// 	ТипАдресногоЭлемента - число - по сути уровень адресного объекта.
//
// Возвращаемое значение:
//	Булево - Истина, если адресные сведения загружены, Ложь - Иначе.
//
Функция ЗагрузитьАдресныеСведения(КодАдресногоОбъекта,
                                  ПутьКДаннымНаСервере,
                                  АдресныеСведения,
                                  АльтернативныеНазвания,
                                  знач ТипАдресногоЭлемента = Неопределено)
	
	ФайлАдресногоКлассификатора = ПутьКДаннымНаСервере +  ".DBF";
	ФайлИндексаКлассификатора   = ПутьКДаннымНаСервере +  ".CDX";
	
	ФайлИндекса = Новый Файл (ФайлИндексаКлассификатора);
	Если НЕ ФайлИндекса.Существует() Тогда
		xB = Новый XBase(ФайлАдресногоКлассификатора);
		xB.Кодировка = КодировкаXBase.OEM;
		
		Если xB.Открыта() Тогда
			// Для загрузки сразу группы адресных сведений удобно
			// пользоваться индексом по всему поле CODE
			xB.индексы.Добавить("IDXCODE", "CODE", Истина);
			xB.СоздатьИндексныйФайл(ФайлИндексаКлассификатора);
			xB.ЗакрытьФайл();
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	xB = Новый XBase(ФайлАдресногоКлассификатора,
	                 ФайлИндексаКлассификатора,
	                 Истина);
	xB.Кодировка = КодировкаXBase.OEM;
	
	// Если мы загружаем улицы или дома, то
	// тип адресного элемента
	Если ТипАдресногоЭлемента <> Неопределено Тогда
		ТипАдресногоЭлементаУстановлен = Истина;
	Иначе
		ТипАдресногоЭлементаУстановлен = Ложь;
	КонецЕсли;
	
	Если Не xB.Открыта() Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Контроль = Новый Соответствие;
	ЕстьОшибки = Ложь;
	
	xB.ТекущийИндекс = xB.Индексы.Найти("IDXCODE");
	
	xB.Найти (КодАдресногоОбъекта, "=");
	
	Пока Не xB.ВКонце() Цикл
		
		Код = xB.CODE;
		
		Если Контроль[Код] = НеОпределено Тогда
			Контроль[Код] = 0;
			
			Если Лев(Код, 2) <> КодАдресногоОбъекта Тогда
				Прервать;
			КонецЕсли;
			
			Если ТипАдресногоЭлементаУстановлен Тогда
				ПризнакАктуальности = Сред(Код, 16, 2);
			Иначе
				ТипАдресногоЭлемента = ПолучитьТипАдресногоЭлементаПоКоду(Код);
				ПризнакАктуальности = Сред(Код, 12, 2);
			КонецЕсли;
			
			// Если это альтернативное название, то заносим сведения в отдельную таблицу
			// альтернативных наименований (для номеров домов альтернативных наименований нет)
			Если  (ТипАдресногоЭлемента <> 6)
				И (ПризнакАктуальности <> "00")
				И (ПризнакАктуальности <> "99") Тогда
				
				СтрокаАльтернативныхНазваний = АльтернативныеНазвания.Добавить();
				СтрокаАльтернативныхНазваний.Код          = Код;
				СтрокаАльтернативныхНазваний.Наименование = СокрЛП(xB.NAME);
				СтрокаАльтернативныхНазваний.Сокращение   = СокрЛП(xB.SOCR);
				СтрокаАльтернативныхНазваний.Индекс       = СокрЛП(xB.INDEX);
				
				xB.Следующая();
				Продолжить;
				
			КонецЕсли;
			
			НоваяСтрока = АдресныеСведения.Добавить();
			
			НоваяСтрока.Код = Код;
			
			НоваяСтрока.ТипАдресногоЭлемента      = ТипАдресногоЭлемента;
			НоваяСтрока.КодАдресногоОбъектаВКоде  = Число(Сред(Код, 1, 2));
			НоваяСтрока.КодРайонаВКоде            = Число(Сред(Код, 3, 3));
			НоваяСтрока.КодГородаВКоде            = Число(Сред(Код, 6, 3));
			НоваяСтрока.КодНаселенногоПунктаВКоде = Число(Сред(Код, 9, 3));
			
			Если ТипАдресногоЭлемента <= 4 Тогда
				НоваяСтрока.КодУлицыВКоде             = 0;
				НоваяСтрока.ПризнакАктуальности       = Число(Сред(Код, 12, 2));
			ИначеЕсли ТипАдресногоЭлемента = 5 Тогда
				НоваяСтрока.КодУлицыВКоде             = Число(Сред(Код, 12, 4));
				НоваяСтрока.ПризнакАктуальности       = Число(Сред(Код, 16, 2));
			Иначе
				НоваяСтрока.КодУлицыВКоде             = Число(Сред(Код, 12, 4));
				НоваяСтрока.ПризнакАктуальности       = 0;
			КонецЕсли;
			
			НоваяСтрока.Наименование = СокрЛП(xB.NAME);
			НоваяСтрока.Индекс       = xB.INDEX;
			НоваяСтрока.Сокращение   = СокрЛП(xB.SOCR);
			
			xB.Следующая();
		Иначе
			ЕстьОшибки = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	xB.ЗакрытьФайл();
	
	Если ЕстьОшибки Тогда
		СтрокаОшибки = НСтр("ru = 'В файле адресного классификатора %1 есть ошибки уникальности кодов'");
		ПараметрыВСтроке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаОшибки, ПутьКДаннымНаСервере);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Адресный классификатор.Загрузка'"), 
									УровеньЖурналаРегистрации.Ошибка, 
									, 
									, 
									ПараметрыВСтроке);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Дополняет адресные сведения альтернативными названиями
//
// Параметры:
// 	ПутьКДаннымНаСервере - Строка - путь к каталогу на сервере, в котором 
//                 хранятся файлы кладр. Путь заканчивается слешем (обратным или прямым)
// 	АдресныеСведения - ТаблицаЗначений - таблица, которая заполняется загружаемыми элементами
// 	АльтернативныеНазвания.
//
// Возвращаемое значение:
//	Булево - Истина, если заполнились альтернативные названия, Ложь - иначе.
///
Функция ЗаполнитьАльтернативныеНазвания(ПутьКДаннымНаСервере,
                                        АдресныеСведения,
                                        АльтернативныеНазвания)
	
	ПутьКФайлуАН        = ПутьКДаннымНаСервере + ".DBF";
	ПутьКФайлуАНИндекс	= ПутьКДаннымНаСервере + ".CDX";
	
	ФайлИндекса = Новый Файл (ПутьКФайлуАНИндекс);
	Если НЕ ФайлИндекса.Существует() Тогда
		xB = Новый XBase(ПутьКФайлуАН);
		xB.Кодировка = КодировкаXBase.OEM;
		Если xB.Открыта() Тогда
			xB.индексы.Добавить("IDXCODE", "OLDCODE", Истина);
			xB.СоздатьИндексныйФайл(ПутьКФайлуАНИндекс);
			xB.ЗакрытьФайл();
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	xB = Новый XBase(ПутьКФайлуАН,
	                 ПутьКФайлуАНИндекс,
	                 Истина);
	
	xB.Кодировка = КодировкаXBase.OEM;
	
	Если xB.Открыта() Тогда
		xB.ТекущийИндекс = xB.Индексы.Найти("IDXCODE");
	КонецЕсли;
	
	Для Каждого АльтернативныйОбъект Из АльтернативныеНазвания Цикл
		
		ПризнакАктуальности = Прав(АльтернативныйОбъект.Код, 2);
		
		КодАктуальногоНаименования = Лев(АльтернативныйОбъект.Код,
		                                 СтрДлина(АльтернативныйОбъект.Код) - 2) + "00";
		
		Если ПризнакАктуальности = "51" Тогда
			// адресную информацию необходимо искать в altnames.dbf
			OLDCODE = КодАктуальногоНаименования;
			xB.Найти (OLDCODE, "=");
			
			НовыйКод = СокрЛП(xB.NewCode);
			
			// пытаемся найти актуальный объект в адресных сведениях
			СтрокаТаблицы = АдресныеСведения.Найти(НовыйКод, "Код");
			
			Если СтрокаТаблицы = Неопределено Тогда
				
				КодУдаленногоНП = Лев(АльтернативныйОбъект.Код, 
				                      СтрДлина(АльтернативныйОбъект.Код) - 2) + "99";
				
				НоваяСтрока = АдресныеСведения.Добавить();
				
				Код = Лев(АльтернативныйОбъект.Код, СтрДлина(АльтернативныйОбъект.Код) - 2) + "00";
				
				ТипАдресногоЭлемента = ПолучитьТипАдресногоЭлементаПоКоду(Код);
				
				НоваяСтрока.Код = Код;
				
				НоваяСтрока.ТипАдресногоЭлемента      = ТипАдресногоЭлемента;
				НоваяСтрока.КодАдресногоОбъектаВКоде  = Число(Сред(Код, 1, 2));
				НоваяСтрока.КодРайонаВКоде            = Число(Сред(Код, 3, 3));
				НоваяСтрока.КодГородаВКоде            = Число(Сред(Код, 6, 3));
				НоваяСтрока.КодНаселенногоПунктаВКоде = Число(Сред(Код, 9, 3));
				
				Если ТипАдресногоЭлемента <= 4 Тогда
					НоваяСтрока.КодУлицыВКоде             = 0;
					НоваяСтрока.ПризнакАктуальности       = Число(Сред(Код, 12, 2));
				ИначеЕсли ТипАдресногоЭлемента = 5 Тогда
					НоваяСтрока.КодУлицыВКоде             = Число(Сред(Код, 12, 4));
					НоваяСтрока.ПризнакАктуальности       = Число(Сред(Код, 16, 2));
				Иначе
					НоваяСтрока.КодУлицыВКоде             = Число(Сред(Код, 12, 4));
					НоваяСтрока.ПризнакАктуальности       = Число(Прав(Код, 2));
				КонецЕсли;
				
				НоваяСтрока.Наименование = СокрЛП(АльтернативныйОбъект.Наименование);
				НоваяСтрока.Индекс       = СокрЛП(АльтернативныйОбъект.Индекс);
				НоваяСтрока.Сокращение   = СокрЛП(АльтернативныйОбъект.Сокращение);
				
				Продолжить;
			КонецЕсли;
			
		Иначе
			
			СтрокаТаблицы = АдресныеСведения.Найти(КодАктуальногоНаименования, "Код");
			
		КонецЕсли; // Если ПризнакАктуальности = "51" Тогда ... Иначе
		
		
		Если СтрокаТаблицы <> Неопределено Тогда
			Если ЗначениеЗаполнено(СокрЛП(АльтернативныйОбъект.Индекс)) Тогда 
				ИндексААО = " : " + АльтернативныйОбъект.Индекс;
			Иначе
				ИндексААО = "";
			КонецЕсли;
			
			АльтернативноеНазвание = АльтернативныйОбъект.Наименование
			                        + " "
			                        + АльтернативныйОбъект.Сокращение
			                        + ИндексААО;
			
			Если СтрокаТаблицы.АльтернативныеНазвания = Неопределено Тогда
				СтрокаТаблицы.АльтернативныеНазвания = АльтернативноеНазвание;
			Иначе
				СтрокаТаблицы.АльтернативныеНазвания =  СтрокаТаблицы.АльтернативныеНазвания
				                                        + ", "
				                                        + АльтернативноеНазвание;
			КонецЕсли;
		КонецЕсли; // Если СтрокаТаблицы <> Неопределено Тогда
		
		СтрокаТаблицы = Неопределено;
		
	КонецЦикла;
	
	Если xB.Открыта() Тогда
		xB.ЗакрытьФайл();
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Процедура для заполнения данных с 2-го по 4-й уровень классификации:
//
// Параметры:
// 	КодАдресногоОбъекта - строка - код адресного объекта в формате NN
// 	АдресныеСведения - ТаблицаЗначений - записи, повторяющие структуру РС АдресныйКлассификатор;
//                    которые переносятся в регистр
//
Процедура ЗаписатьКлассификатор(КодАдресногоОбъекта, АдресныеСведения)
	
	Для Каждого Элемент Из АдресныеСведения Цикл
		
		КодСтрока = Строка(Элемент.Код);
		ДлинаСтрокиКода = СтрДлина(КодСтрока);
		
		Для Индекс = ДлинаСтрокиКода По 20 Цикл
			КодСтрока = КодСтрока + "0";
		КонецЦикла;
		
		Элемент.Код = КодСтрока;
		
	КонецЦикла;
	
	НаборАдресныхСведений = РегистрыСведений.АдресныйКлассификатор.СоздатьНаборЗаписей();
	НаборАдресныхСведений.Отбор.КодАдресногоОбъектаВКоде.Использование = Истина;
	НаборАдресныхСведений.Отбор.КодАдресногоОбъектаВКоде.Значение = Число(КодАдресногоОбъекта);
	НаборАдресныхСведений.Загрузить(АдресныеСведения);
	НаборАдресныхСведений.Записать();
	
КонецПроцедуры

// Функция получает уровень адресного элемента (всего 6 уровней) в 
// иерархической системе классификации по его коду
// формат кода:
// _2__3___3___3___4____4____
// |СС|РРР|ГГГ|ППП|УУУУ|ДДДД|
// 
// чем глубже уровень иерархии тем более младшие разряды являются заполненными
//
// Параметры:
// 	Код           - строка - код, взятый из поля записи CODE файла данных
// 
// Возвращаемое значение:
// 	Число [1-6]
Функция ПолучитьТипАдресногоЭлементаПоКоду(знач Код)
	
	Размерность = СтрДлина(Код);
	
	// для кодов с размерностью 13 или 17 необходимо уменьшить код
	// на 2 разряда - символы актуальности адресного объекта
	Если Размерность = 13 ИЛИ Размерность = 17 Тогда
		Размерность = Размерность - 2;
		КодЧисло = Число(Сред(Код, 1, СтрДлина(Код)-2));
	ИначеЕсли Размерность = 19 Тогда
		КодЧисло = Число(Сред(Код, 1, СтрДлина(Код)));
	КонецЕсли;
	
	// Проверяем заполненность разрядов ДДДД
	Если Размерность = 19 Тогда
		
		Остаток = КодЧисло % 10000;
		Если Остаток <> 0 Тогда
			Возврат 6;
		КонецЕсли;
		
		КодЧисло = КодЧисло / 10000;
		
	КонецЕсли;
	
	// Проверяем заполненность разрядов УУУУ
	Если Размерность = 15 Тогда
		
		Остаток = КодЧисло % 10000;
		Если Остаток <> 0 Тогда
			Возврат 5;
		КонецЕсли;
		
		КодЧисло = КодЧисло / 10000;
		
	КонецЕсли;
	
	// Проверяем заполненность разрядов ППП
	Остаток = КодЧисло % 1000;
	Если Остаток <> 0 Тогда
		Возврат 4;
	КонецЕсли;
	
	// Проверяем заполненность разрядов ГГГ
	Остаток = КодЧисло % 1000000;
	Если Остаток <> 0 Тогда
		Возврат 3;
	КонецЕсли;
	
	// Проверяем заполненность разрядов РРР
	Остаток = КодЧисло % 1000000000;
	Если Остаток <> 0 Тогда
		Возврат 2;
	КонецЕсли;
	
	// Верхний уровень иерархии - единица
	
	Возврат 1;
	
КонецФункции

// Читает значение атрибута по имени из указанного объекта, приводит значение
// к указанному примитивному типу
//
// Параметры:
//  ЧтениеXML      - объект типа ЧтениеXML, спозиционированный на начале элемента,
//                атрибут которого требуется получить
//  Тип         - Значение типа Тип. Тип атрибута
//  Имя         - Строка. Имя атрибута
//
// Возвращаемое значение:
// 	Строка - значение атрибута полученное по имени и приведенное к указанному типу
//
Функция ПолучитьАтрибут(знач ЧтениеXML, Знач Имя)
	
	ЗначениеСтрока = СокрЛП(ЧтениеXML.ПолучитьАтрибут(Имя));
	
	Если		Имя = "date" Тогда
		Возврат Дата(Сред(ЗначениеСтрока, 7, 4) + Сред(ЗначениеСтрока, 4, 2) + Лев(ЗначениеСтрока, 2));
	ИначеЕсли	Имя = "code" Тогда
		Возврат Лев(ЗначениеСтрока, 2);
	КонецЕсли;
	
КонецФункции

// Добавляет версию в список.
//
// Параметры:
//	АдресныйОбъект - Число - адресный объект.
//	Версии - Массив - массив версий.
//	Список - СписокЗначений.
//
Процедура ДобавитьВерсиюВСписок(АдресныйОбъект, Версии, Список)
	
	ЭлементСписка = Список.Добавить();
	ЭлементСписка.Представление = АдресныйОбъект;
	
	ОписаниеВерсии = Версии.Найти(АдресныйОбъект, "АдресныйОбъект");
	Если ОписаниеВерсии = Неопределено Тогда
		ЭлементСписка.Значение = '00000000';
	Иначе
		ЭлементСписка.Значение = ОписаниеВерсии.ДатаВыпускаВерсии;
	КонецЕсли;
	
КонецПроцедуры

// По коду и типу адресного элемента получает коды его составных частей
//
// Параметры:
// 	КодАдресногоЭлемента  - строка или число - номер адресного объекта
// 	ТипАдресногоЭлемента - число - уровень адресного объекта.
//
// Возвращаемое значение:
// 	Структура с полями:
// 		КодАдресногоОбъектаВКоде  - число - код элемента региона
// 		КодРайонаВКоде - число - код элемента района
// 		КодГородаВКоде  - число - код элемента города
// 		КодНаселенногоПунктаВКоде - число - код элемента населенного пункта
// 		КодУлицыВКоде  - число - код элемента улицы
// 		ПризнакАктуальности - число - код элемента признака актуальности
//
Функция РазобратьАдресныйОбъектПоЭлементам(КодАдресногоЭлемента, ТипАдресногоЭлемента)
	
	Если ТипЗнч(КодАдресногоЭлемента) = Тип("Число") Тогда
		КодСтрокой = Формат(КодАдресногоЭлемента, "ЧГ=0");
	Иначе
		КодСтрокой = КодАдресногоЭлемента;
	КонецЕсли;
	
	СтруктураАдреса = Новый Структура;
	СтруктураАдреса.Вставить("КодАдресногоОбъектаВКоде", Число(Лев(КодСтрокой, 2)));
	
	Если ТипАдресногоЭлемента > 1 Тогда
		СтруктураАдреса.Вставить("КодРайонаВКоде", Число(Сред(КодСтрокой, 3, 3)));
	Иначе
		СтруктураАдреса.Вставить("КодРайонаВКоде", 0);
	КонецЕсли;
	
	Если ТипАдресногоЭлемента > 2 Тогда
		СтруктураАдреса.Вставить("КодГородаВКоде", Число(Сред(КодСтрокой, 6, 3)));
	Иначе
		СтруктураАдреса.Вставить("КодГородаВКоде", 0);
	КонецЕсли;
	
	Если ТипАдресногоЭлемента > 3 Тогда
		СтруктураАдреса.Вставить("КодНаселенногоПунктаВКоде", Число(Сред(КодСтрокой, 9, 3)));
	Иначе
		СтруктураАдреса.Вставить("КодНаселенногоПунктаВКоде", 0);
	КонецЕсли;
	
	Если ТипАдресногоЭлемента > 4 Тогда
		СтруктураАдреса.Вставить("КодУлицыВКоде", Число(Сред(КодСтрокой, 12, 4)));
		СтруктураАдреса.Вставить("ПризнакАктуальности", Число(Сред(КодСтрокой, 16, 2)));
	Иначе
		СтруктураАдреса.Вставить("КодУлицыВКоде", 0);
		СтруктураАдреса.Вставить("ПризнакАктуальности", Число(Сред(КодСтрокой, 12, 2)));
	КонецЕсли;
	
	Возврат СтруктураАдреса;
	
КонецФункции
