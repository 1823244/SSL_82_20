﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Рассылка отчетов" (клиент, сервер)
// 
// Выполняется на клиенте и на сервере.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Разбирает строку FTP адреса на Логин, Пароль, Сервер, Порт и Каталог
//   Подробнее - см. RFC 1738 (http://tools.ietf.org/html/rfc1738#section-3.1)
//   Шаблон: ftp://<user>:<password>@<host>:<port>/<url-path>
// 
// Параметры:
//   FTPАдрес (Строка)
// 
// Возвращаемое значение: 
//   Результат (Структура)
//       |- Логин (Строка)
//       |- Пароль (Строка)
//       |- Сервер (Строка)
//       |- Порт (Число) - По умолчанию 21
//       |- Каталог (Строка) - Первый символ всегда "/"
//
Функция РазобратьFTPАдрес(ПолныйFTPАдрес) Экспорт
	Результат = Новый Структура("Логин, Пароль, Сервер, Порт, Каталог", "", "", "", 21, "/");
	FTPАдрес = ПолныйFTPАдрес;
	
	// Вырезать 'ftp://'
	Поз = Найти(FTPАдрес, "://");
	Если Поз > 0 Тогда
		FTPАдрес = Сред(FTPАдрес, Поз + 3);
	КонецЕсли;
	
	// Каталог
	Поз = Найти(FTPАдрес, "/");
	Если Поз > 0 Тогда
		Результат.Каталог = Сред(FTPАдрес, Поз);
		FTPАдрес = Лев(FTPАдрес, Поз - 1);
	КонецЕсли;
	
	// Логин и пароль
	Поз = Найти(FTPАдрес, "@");
	Если Поз > 0 Тогда
		ЛогинПароль = Лев(FTPАдрес, Поз - 1);
		FTPАдрес = Сред(FTPАдрес, Поз + 1);
		
		Поз = Найти(ЛогинПароль, ":");
		Если Поз > 0 Тогда
			Результат.Логин = Лев(ЛогинПароль, Поз - 1);
			Результат.Пароль = Сред(ЛогинПароль, Поз + 1);
		Иначе
			Результат.Логин = ЛогинПароль;
		КонецЕсли;
	КонецЕсли;
	
	// Сервер и порт
	Поз = Найти(FTPАдрес, ":");
	Если Поз > 0 Тогда
		Результат.Сервер = Лев(FTPАдрес, Поз - 1);
		Результат.Порт = СтрокуВЧисло(Сред(FTPАдрес, Поз + 1), Результат.Порт);
	Иначе
		Результат.Сервер = FTPАдрес;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Заполняет шаблон из структуры параметров, поддерживает форматирование, может оставлять обрамление шаблона
//   Ограничение: должны присутствовать и левый и правый элементы обрамления
// 
// Параметры:
//   Шаблон (Строка) - Исходный шаблон
//   Параметры (Структура) - Набор параметров, которые необходимо подставить в шаблон
//   Левый (Строка)  - Начало обрамления параметра
//   Правый (Строка) - Конец  обрамления параметра
//   ФорматЛевый (Строка)  - Начало обрамления формата параметра
//   ФорматПравый (Строка) - Конец  обрамления формата параметра
//   ВырезатьОбрамление (Булево) - Ложь означает, что обрамление параметра будет убрано из результата
// 
// Возвращаемое значение: 
//   Результат (Строка) - Результат заполнения
//
Функция ЗаполнитьШаблон(Шаблон, Параметры, Левый = "[", Правый = "]", ФорматЛевый = "(", ФорматПравый = ")", ВырезатьОбрамление = Истина) Экспорт
	Результат = Шаблон;
	Для Каждого КлючИЗначение Из Параметры Цикл
		// Замена [ключ] на [значение]
		Результат = СтрЗаменить(
			Результат,
			Левый + КлючИЗначение.Ключ + Правый, 
			?(ВырезатьОбрамление, "", Левый) + КлючИЗначение.Значение + ?(ВырезатьОбрамление, "", Правый)
		);
		ДлинаФорматЛевый = СтрДлина(Левый + КлючИЗначение.Ключ + ФорматЛевый);
		// Замена [ключ(формат)] на [значение] в формате
		Поз1 = Найти(Результат, Левый + КлючИЗначение.Ключ + ФорматЛевый);
		Пока Поз1 > 0 Цикл
			Поз2 = Найти(Результат, ФорматПравый + Правый);
			Если Поз2 = 0 Тогда
				Прервать;
			КонецЕсли;
			ФорматнаяСтрока = Сред(Результат, Поз1 + ДлинаФорматЛевый, Поз2 - Поз1 - ДлинаФорматЛевый);
			Попытка
				НаЧтоЗаменить = ?(ВырезатьОбрамление, "", Левый) + Формат(КлючИЗначение.Значение, ФорматнаяСтрока) + ?(ВырезатьОбрамление, "", Правый);
			Исключение
				НаЧтоЗаменить = ?(ВырезатьОбрамление, "", Левый) + КлючИЗначение.Значение + ?(ВырезатьОбрамление, "", Правый);
			КонецПопытки;
			Результат = СтрЗаменить(
				Результат,
				Левый + КлючИЗначение.Ключ + ФорматЛевый + ФорматнаяСтрока + ФорматПравый + Правый, 
				НаЧтоЗаменить
			);
			Поз1 = Найти(Результат, Левый + КлючИЗначение.Ключ + ФорматЛевый);
		КонецЦикла;
	КонецЦикла;
	Возврат Результат;
КонецФункции

// Возвращает шаблон темы по умолчанию для доставки по электронной почте
// 
Функция ШаблонТемы() Экспорт
	Возврат НСтр("ru = '[НаименованиеРассылки] от [ДатаВыполнения(ДЛФ=''D'')]'");
КонецФункции

// Возвращает шаблон тела сообщения по умолчанию для доставки по электронной почте
// 
Функция ШаблонТекста() Экспорт
	Возврат НСтр("ru = 'Сформированы отчеты:
                  |
				  |[СформированныеОтчеты]
                  |
				  |[СпособДоставки]
                  |
                  |[ЗаголовокСистемы]
                  |[ДатаВыполнения(ДЛФ=''DD'')]'");
	//
КонецФункции

// Возвращает шаблон наименования архива по умолчанию
// 
Функция ШаблонИмениАрхива() Экспорт
	Возврат НСтр("ru = '[НаименованиеРассылки]_[ДатаВыполнения(ДФ=''yyyy-MM-dd'')]'"); // Формат даты не локализуется
КонецФункции

// Возвращает набор шаблонов заполнения расписаний регламентного задания
// 
Функция СписокВариантовЗаполненияРасписаний() Экспорт
	
	СписокВариантов = Новый СписокЗначений;
	СписокВариантов.Добавить(1, НСтр("ru = 'Каждый день'"));
	СписокВариантов.Добавить(2, НСтр("ru = 'Каждый второй день'"));
	СписокВариантов.Добавить(3, НСтр("ru = 'Каждый четвертый день'"));
	СписокВариантов.Добавить(4, НСтр("ru = 'По будням'"));
	СписокВариантов.Добавить(5, НСтр("ru = 'По выходным'"));
	СписокВариантов.Добавить(6, НСтр("ru = 'По понедельникам'"));
	СписокВариантов.Добавить(7, НСтр("ru = 'По пятницам'"));
	СписокВариантов.Добавить(8, НСтр("ru = 'По воскресеньям'"));
	СписокВариантов.Добавить(9, НСтр("ru = 'В первый день месяца'"));
	СписокВариантов.Добавить(10, НСтр("ru = 'В последний день месяца'"));
	СписокВариантов.Добавить(11, НСтр("ru = 'Каждый квартал десятого числа'"));
	СписокВариантов.Добавить(12, НСтр("ru = 'Другое...'"));
	
	Возврат СписокВариантов;
КонецФункции

// Преобразует массив сообщений пользователю в одну строку
// 
Функция СтрокаСообщенийПользователю(МассивОшибок = Неопределено, ДобавитьДежурнуюФразу = Истина) Экспорт
	Если МассивОшибок = Неопределено Тогда
		МассивОшибокПолучен = Ложь;
		#Если Сервер ИЛИ ТолстыйКлиент Тогда
			МассивОшибок = ПолучитьСообщенияПользователю(Истина);
			МассивОшибокПолучен = Истина;
		#КонецЕсли
		Если НЕ МассивОшибокПолучен Тогда
			Возврат "";
		КонецЕсли;
	КонецЕсли;
	
	Отступ = Символы.ПС + Символы.ПС;
	
	ВсеОшибки = "";
	Для Каждого Ошибка Из МассивОшибок Цикл
		ВсеОшибки = СокрЛП(ВсеОшибки + Отступ + ?(ТипЗнч(Ошибка) = Тип("Строка"), Ошибка, Ошибка.Текст));
	КонецЦикла;
	Если ВсеОшибки <> "" И ДобавитьДежурнуюФразу Тогда
		ВсеОшибки = ВсеОшибки + Отступ + "---" + Отступ + НСтр("ru = 'Подробности см. в журнале регистрации.'");
	КонецЕсли;
	
	Возврат ВсеОшибки;
КонецФункции

// Превращает строку в число без вызова исключений. Стандартная функция преобразования
//   Число() строго контролирует отсутствие каких либо символов кроме числовых.
// 
Функция СтрокуВЧисло(ИсходнаяСтрока, ЗначениеПоУмолчанию = 0)
	СтрокаВЧисло = Новый Соответствие;
	Для Значение = 0 По 9 Цикл
		СтрокаВЧисло.Вставить(Строка(Значение), Значение);
	КонецЦикла;
	
	Результат = 0;
	Для Индекс = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		ПоследнийРазряд = СтрокаВЧисло.Получить(Сред(ИсходнаяСтрока, Индекс, 1));
		Если ПоследнийРазряд <> Неопределено Тогда
			Результат = Результат * 10 + ПоследнийРазряд;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ?(Результат = 0, ЗначениеПоУмолчанию, Результат);
КонецФункции

