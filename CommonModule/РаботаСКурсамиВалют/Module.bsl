﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Валюты"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает курс валюты на дату
// 
// Параметры:
//   Валюта    (СправочникСсылка.Валюты) Валюта, для которой получается курс
//   ДатаКурса (Дата) Дата, на которую получается курс
// 
// Возвращаемое значение: 
//   (Структура) 
//       |- Валюта    (СправочникСсылка.Валюты)
//       |- Курс      (Число)
//       |- Кратность (Число)
//       |- ДатаКурса (Дата)
// 
Функция ПолучитьКурсВалюты(Валюта, ДатаКурса) Экспорт
	
	Результат = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ДатаКурса, Новый Структура("Валюта", Валюта));
	
	Результат.Вставить("Валюта",    Валюта);
	Результат.Вставить("ДатаКурса", ДатаКурса);
	
	Возврат Результат;
	
КонецФункции

// Формирует представление суммы прописью в указанной валюте
// 
// Параметры:
//   СуммаЧислом (Число) Сумма, которую надо представить прописью
//   Валюта (СправочникСсылка.Валюты) Валюта, в которой нужно представить сумму
//   ВыводитьСуммуБезКопеек  (Булево) Флаг представления суммы без копеек
// 
// Возвращаемое значение: 
//   (Строка) Сумма прописью
// 
Функция СформироватьСуммуПрописью(СуммаЧислом, Валюта, ВыводитьСуммуБезКопеек = Ложь) Экспорт
	
	Сумма             = ?(СуммаЧислом < 0, -СуммаЧислом, СуммаЧислом);
	ПараметрыПредмета = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Валюта, "ПараметрыПрописиНаРусском");
	
	Результат = ЧислоПрописью(Сумма, "Л=ru_RU;ДП=Ложь", ПараметрыПредмета.ПараметрыПрописиНаРусском);
	
	Если ВыводитьСуммуБезКопеек И Цел(Сумма) = Сумма Тогда
		Результат = Лев(Результат, Найти(Результат, "0") - 1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Выполнение регламентных заданий

// Загружает курсы валют на текущую дату
//
Процедура ЗагрузитьАктуальныйКурс() Экспорт
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	ИмяСобытия = НСтр("ru = 'Валюты.Загрузка курсов валют'");
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытия,
		УровеньЖурналаРегистрации.Информация,
		,
		,
		НСтр("ru = 'Начата регламентная загрузка курсов валют'")
	);
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	СостояниеЗагрузки = Неопределено;
	ПриЗагрузкеВозниклиОшибки = Неопределено;
	
	ОбработкаЗагрузкиКурсовВалют = Обработки.ЗагрузкаКурсовВалют.Создать();
	ОбработкаЗагрузкиКурсовВалют.НачалоПериодаЗагрузки = ТекущаяДата;
	ОбработкаЗагрузкиКурсовВалют.ОкончаниеПериодаЗагрузки = ТекущаяДата;
	ОбработкаЗагрузкиКурсовВалют.ЗаполнитьСписокВалют();
	ОбработкаЗагрузкиКурсовВалют.ЗагрузитьКурсыВалют(ПриЗагрузкеВозниклиОшибки);
	
	Если ПриЗагрузкеВозниклиОшибки Тогда
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,
			, 
			,
			НСтр("ru = 'Во время регламентного задания загрузки курсов валют возникли ошибки'")
		);
	Иначе
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Информация,
			,
			,
			НСтр("ru = 'Завершена регламентная загрузка курсов валют.'")
		);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции

// Копирует в регистр сведений подчиненной валюты всю информацию из регистра
// сведений базовой валюты (период, курс, кратность).
//
// Параметры
//  ВалютаИсточник – Справочники.Валюты – ссылка на базовую валюту, из регистра
//                 сведений которой, будут копироваться данные
//  ВалютаПриемник – Справочники.Валюты – ссылка на зависимую валюту от базовой,
//                 в регистр сведений которой данные будут копироваться
//
Процедура ЗаписатьСведенияДляПодчиненногоРегистра(ВалютаИсточник, ВалютаПриемник) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ *
	              | ИЗ РегистрСведений.КурсыВалют
	              | ГДЕ Валюта = &ВалютаИсточник";
	Запрос.УстановитьПараметр("ВалютаИсточник", ВалютаИсточник);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	НаборКурсов = РегистрКурсыВалют.СоздатьНаборЗаписей();
	
	НаборКурсов.Отбор.Валюта.ВидСравнения  = ВидСравнения.Равно;
	НаборКурсов.Отбор.Валюта.Значение      = ВалютаПриемник;
	НаборКурсов.Отбор.Валюта.Использование = Истина;
	
	Наценка = ВалютаПриемник.Наценка;
	
	Пока Выборка.Следующий() Цикл
		
		НоваяЗаписьНабораКурсов = НаборКурсов.Добавить();
		НоваяЗаписьНабораКурсов.Валюта    = ВалютаПриемник;
		НоваяЗаписьНабораКурсов.Кратность = Выборка.Кратность;
		НоваяЗаписьНабораКурсов.Курс      = Выборка.Курс + Выборка.Курс*Наценка/100;
		НоваяЗаписьНабораКурсов.Период    = Выборка.Период;
		
	КонецЦикла;
	
	НаборКурсов.Записать();
	
КонецПроцедуры

// Проверяет наличие установленного курса и кратности валюты на 1 января 1980 года.
// В случае отсутствия устанавливает курс и кратность равными единице.
//
// Параметры:
//  Валюта - ссылка на элемент справочника Валют
//
Процедура ПроверитьКорректностьКурсаНа01_01_1980(Валюта) Экспорт
	
	ДатаКурса = Дата("19800101");
	СтруктураКурса = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ДатаКурса, Новый Структура("Валюта", Валюта));
	
	Если (СтруктураКурса.Курс = 0) Или (СтруктураКурса.Кратность = 0) Тогда
		
		РегистрКурсыВалют = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
		
		РегистрКурсыВалют.Период    = ДатаКурса;
		РегистрКурсыВалют.Валюта    = Валюта;
		РегистрКурсыВалют.Курс      = 1;
		РегистрКурсыВалют.Кратность = 1;
		РегистрКурсыВалют.Записать();
	КонецЕсли;
	
КонецПроцедуры // ПроверитьКорректностьКурсаНа01_01_1980()

// Загружает информацию о курсе валюты Валюта из файла ПутьКФайлу в регистр
// сведений курсов валют. При этом файл с курсами разбирается, и записываются
// только те данные, которые удовлетворяют периоду (НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки).
//
Функция ЗагрузитьКурсВалютыИзФайла(знач Валюта, знач ПутьКФайлу, знач НачалоПериодаЗагрузки, знач ОкончаниеПериодаЗагрузки) Экспорт
	
	СтатусЗагрузки = 1;
	
	ЧислоЗагружаемыхДнейВсего = 1 + (ОкончаниеПериодаЗагрузки - НачалоПериодаЗагрузки) / ( 24 * 60 * 60);
	
	ЧислоЗагруженныхДней = 0;
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла();
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПутьКФайлу);
		ДвоичныеДанные.Записать(ИмяФайла);
	Иначе
		ИмяФайла = ПутьКФайлу;
	КонецЕсли;
	
	Текст = Новый ТекстовыйДокумент();
	
	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	
	Текст.Прочитать(ИмяФайла, КодировкаТекста.ANSI);
	КолСтрок = Текст.КоличествоСтрок();
	
	Для Инд = 1 По КолСтрок Цикл
		
		Стр = Текст.ПолучитьСтроку(Инд);
		Если (Стр = "") ИЛИ (Найти(Стр,Символы.Таб) = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
			ДатаКурса = ОкончаниеПериодаЗагрузки;
		Иначе
			ДатаКурсаСтр = ВыделитьПодСтроку(Стр);
			ДатаКурса    = Дата(Лев(ДатаКурсаСтр,4), Сред(ДатаКурсаСтр,5,2), Сред(ДатаКурсаСтр,7,2));
		КонецЕсли;
		
		Кратность = Число(ВыделитьПодСтроку(Стр));
		Курс      = Число(ВыделитьПодСтроку(Стр));
		
		Если ДатаКурса > ОкончаниеПериодаЗагрузки Тогда
			Прервать;
		КонецЕсли;
		
		Если ДатаКурса < НачалоПериодаЗагрузки Тогда 
			Продолжить;
		КонецЕсли;
		
		ЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();
		
		ЗаписьКурсовВалют.Валюта    = Валюта;
		ЗаписьКурсовВалют.Период    = ДатаКурса;
		ЗаписьКурсовВалют.Курс      = Курс;
		ЗаписьКурсовВалют.Кратность = Кратность;
		ЗаписьКурсовВалют.Записать();
		
		ЧислоЗагруженныхДней = ЧислоЗагруженныхДней + 1;
	КонецЦикла;
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		УдалитьФайлы(ИмяФайла);
		УдалитьИзВременногоХранилища(ПутьКФайлу);
	КонецЕсли;
	
	Если ЧислоЗагружаемыхДнейВсего = ЧислоЗагруженныхДней Тогда
		ПояснениеОЗагрузке = "";
	ИначеЕсли ЧислоЗагруженныхДней = 0 Тогда
		ПояснениеОЗагрузке = НСтр("ru = 'Курсы валюты %1 - %2 не загружены. Нет данных.'");
	Иначе
		ПояснениеОЗагрузке = НСтр("ru = 'Загружены не все курсы по валюте %1 - %2.'");
	КонецЕсли;
	
	ПояснениеОЗагрузке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ПояснениеОЗагрузке,
									Валюта.Код,
									Валюта.Наименование);
	
	Возврат ПояснениеОЗагрузке;
	
КонецФункции

// Возвращает массив валют, курсы которых загружаются с сайта РБК
//
Функция ПолучитьМассивЗагружаемыхВалют() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
					|	Ссылка КАК Ссылка
					|ИЗ
					|	Справочник.Валюты КАК Валюты
					|ГДЕ
					|	Валюты.ЗагружаетсяИзИнтернета";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Возвращает информацию о курсе валюты на основе ссылки на валюту.
// Данные возвращаются в виде структуры.
//
// Параметры:
// ВыбраннаяВалюта - Справочник.Валюты / Ссылка - ссылка на валюту, информацию
//                  о курсе которой необходимо получить
//
// Возвращаемое значение:
// ДанныеКурса   - стуктура, содержащая информацию о последней доступной 
//                 записи курса
//
Функция ЗаполнитьДанныеКурсаДляВалюты(ВыбраннаяВалюта) Экспорт
	
	ДанныеКурса = Новый Структура("ДатаКурса, Курс, Кратность");
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РегКурсы.Период, РегКурсы.Курс, РегКурсы.Кратность
	              | ИЗ РегистрСведений.КурсыВалют.СрезПоследних(&ОкончаниеПериодаЗагрузки, Валюта = &ВыбраннаяВалюта) КАК РегКурсы";
	Запрос.УстановитьПараметр("ВыбраннаяВалюта", ВыбраннаяВалюта);
	Запрос.УстановитьПараметр("ОкончаниеПериодаЗагрузки", ТекущаяДатаСеанса());
	
	ВыборкаКурс = Запрос.Выполнить().Выбрать();
	ВыборкаКурс.Следующий();
	
	ДанныеКурса.ДатаКурса = ВыборкаКурс.Период;
	ДанныеКурса.Курс      = ВыборкаКурс.Курс;
	ДанныеКурса.Кратность = ВыборкаКурс.Кратность;
	
	Возврат ДанныеКурса;
	
КонецФункции

// Возвращает таблицу значений - валюты, зависящие от переданной
// в качестве параметра.
// Возвращаемое значение
// ТаблицаЗначений
// колонка "Ссылка" - СправочникСсылка.Валюты
// колонка "Наценка" - число
//
Функция ПолучитьСписокЗависимыхВалют(знач ВалютаБазовая) Экспорт
	
	Запрос	= Новый Запрос;
	Запрос.Текст = "Выбрать Ссылка, Наценка
					|ИЗ
					|	Справочник.Валюты Как СпрВалюты
					|ГДЕ
					|	ОсновнаяВалюта = &ВалютаБазовая";
	
	Запрос.УстановитьПараметр("ВалютаБазовая", ВалютаБазовая);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.5.9";
	Обработчик.Процедура = "РаботаСКурсамиВалют.ОбновитьФорматХраненияПрописиНаРусскомЯзыке";
	
КонецПроцедуры

// Обработчик обновления формата хранения прописей при переходе на более новую версию БСП
//
Процедура ОбновитьФорматХраненияПрописиНаРусскомЯзыке() Экспорт
	
	ВыборкаВалют = Справочники.Валюты.Выбрать();
	
	Пока ВыборкаВалют.Следующий() Цикл
		Объект = ВыборкаВалют.ПолучитьОбъект();
		СтрокаПараметров = СтрЗаменить(Объект.ПараметрыПрописиНаРусском, ",", Символы.ПС);
		Род1 = НРег(Лев(СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 4)), 1));
		Род2 = НРег(Лев(СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 8)), 1));
		Объект.ПараметрыПрописиНаРусском = 
					  СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 1)) + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 2)) + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 3)) + ", "
					+ Род1 + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 5)) + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 6)) + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 7)) + ", "
					+ Род2 + ", "
					+ СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 9));
		Объект.Записать();
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции

// Выделяет из переданной строки первое значение
 //  до символа "TAB"
 //
 // Параметры: 
 //  ИсходнаяСтрока - Строка - строка для разбора
 //
 // Возвращаемое значение:
 //  подстроку до символа "TAB"
 //
Функция ВыделитьПодСтроку(ИсходнаяСтрока)
	
	Перем ПодСтрока;
	
	Поз = Найти(ИсходнаяСтрока,Символы.Таб);
	Если Поз > 0 Тогда
		ПодСтрока = Лев(ИсходнаяСтрока,Поз-1);
		ИсходнаяСтрока = Сред(ИсходнаяСтрока,Поз + 1);
	Иначе
		ПодСтрока = ИсходнаяСтрока;
		ИсходнаяСтрока = "";
	КонецЕсли;
	
	Возврат ПодСтрока;
	
КонецФункции
