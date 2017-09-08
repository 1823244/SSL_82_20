﻿// Возвращает структуру, содержащую различные персональные настройки
// по работе с файлами
Процедура ПолучитьПерсональныеНастройкиРаботыСФайлами(Настройки) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиВызовСервера.ПолучитьПерсональныеНастройкиФайловыхФункций(Настройки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

// При переименовании пользователя переносит его настройки - РабочийКаталог, ДействиеПоДвойномуЩелчкуМыши и пр
//
Процедура ПеренестиНастройкиПриСменеИмениПользователя(знач ИмяТекущее, знач ИмяУстанавливаемое) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиВызовСервера.ПеренестиНастройкиПриСменеИмениПользователя(ИмяТекущее, ИмяУстанавливаемое);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

// Вызывается при обмене данными для определения пути к файлу.
//
// Параметры
//   ЭлементДаннных          - элемент данных, изменение которого зарегистрировано и который 
//                             должен быть помещен в сообщение обмена данными. 
//   ИмяКаталогаФайлов       - Строка - имя каталога к файлу. 
//   УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор файла.
//   ПутьФайла               - Строка - в этом параметре требуется вернуть путь к файлу.
//
//
Процедура УстановитьИмяФайлаПриОтправкеДанныхФайла(ЭлементДанных, ИмяКаталогаФайлов, УникальныйИдентификатор, ПутьФайла) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиСобытия.УстановитьИмяФайлаПриОтправкеДанныхФайла(ЭлементДанных, ИмяКаталогаФайлов, УникальныйИдентификатор, ПутьФайла);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлыСобытия.УстановитьИмяФайлаПриОтправкеДанныхФайла(ЭлементДанных, ИмяКаталогаФайлов, УникальныйИдентификатор, ПутьФайла);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

// Удаляет файл при обмене
//
Процедура УдалитьФайлыПриПолученииДанныхФайла(ЭлементДанных, ПутьСПодкаталогом) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиВызовСервера.УдалитьФайлыПриПолученииДанныхФайла(ЭлементДанных, ПутьСПодкаталогом);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

// Добавляет файл на том при обмене
//
Процедура ДобавитьНаДискПриПолученииДанныхФайла(ЭлементДанных, ДвоичныеДанные, ПутьКФайлуНаТоме, СсылкаНаТом, ВремяИзменения, 
	ИмяБезРасширения, Расширение, РазмерФайла, Зашифрован) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиСобытия.ДобавитьНаДискПриПолученииДанныхФайла(ЭлементДанных, ДвоичныеДанные, ПутьКФайлуНаТоме, СсылкаНаТом, 
		ВремяИзменения, ИмяБезРасширения, Расширение, РазмерФайла);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлыСобытия.ДобавитьНаДискПриПолученииДанныхФайла(ЭлементДанных, ДвоичныеДанные, ПутьКФайлуНаТоме, СсылкаНаТом, 
		ВремяИзменения, ИмяБезРасширения, Расширение, РазмерФайла, Зашифрован);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

// Добавляет файл на том при "Разместить файлы начального образа"
//
Процедура ДобавитьФайлыВТомаПриРазмещении(СоответствиеПутейФайлов, ХранитьФайлыВТомахНаДиске, ПрисоединяемыеФайлы) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиВызовСервера.ДобавитьФайлыВТомаПриРазмещении(СоответствиеПутейФайлов, ХранитьФайлыВТомахНаДиске);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлы.ДобавитьФайлыВТомаПриРазмещении(СоответствиеПутейФайлов, ХранитьФайлыВТомахНаДиске, ПрисоединяемыеФайлы);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

// Удаляет регистрацию изменений после "Разместить файлы начального образа"
//
Процедура УдалитьРегистрациюИзменений(ПланОбменаСсылка, ПрисоединяемыеФайлы) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиВызовСервера.УдалитьРегистрациюИзменений(ПланОбменаСсылка);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлы.УдалитьРегистрациюИзменений(ПланОбменаСсылка, ПрисоединяемыеФайлы);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

// Возвращает Истина, если это элемент данных - Версия файла или Присоединенный файл.
//
Процедура ЭтоЭлементФайл(ЭлементДанных, ЭтоФайл) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиСобытия.ЭтоЭлементФайл(ЭлементДанных, ЭтоФайл);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлыСобытия.ЭтоЭлементФайл(ЭлементДанных, ЭтоФайл);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

// Возвращает Истина, если это элемент данных - ХранимыеФайлыВерсий
//
Процедура ЭтоЭлементХранимыеФайлыВерсий(ЭлементДанных, ЭтоФайл) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиСобытия.ЭтоЭлементХранимыеФайлыВерсий(ЭлементДанных, ЭтоФайл);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

// Возвращает Истина в параметре Значение, если элемент данных (справочник Файл) запрещен к загрузке
//
Процедура ЭлементЗапрещенКЗагрузке(ЭлементДанных, ПолучениеЭлемента, Значение) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиСобытия.ЭлементЗапрещенКЗагрузке(ЭлементДанных, ПолучениеЭлемента, Значение);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

// Возвращает структуру с двоичными данными файла и подписи
//
Функция ПолучитьДвоичныеДанныеФайлаИПодписи(ДанныеСтроки) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если РаботаСФайламиСобытия.ЭтоЭлементРаботаСФайлами(ДанныеСтроки.Объект) Тогда
		Возврат РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИДвоичныеДанные(, ДанныеСтроки.Объект, ДанныеСтроки.АдресПодписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	Если ПрисоединенныеФайлыСобытия.ЭтоЭлементПрисоединенныеФайлы(ДанныеСтроки.Объект) Тогда
		Возврат ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайлаИПодписи(ДанныеСтроки.Объект, ДанныеСтроки.АдресПодписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает текст запроса для извлечения текста
//
Процедура ПолучитьТекстЗапросаДляИзвлеченияТекста(ТекстЗапроса, ПолучитьВсеФайлы = Ложь) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиВызовСервера.ПолучитьТекстЗапросаДляИзвлеченияТекста(ТекстЗапроса, ПолучитьВсеФайлы);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлы.ПолучитьТекстЗапросаДляИзвлеченияТекста(ТекстЗапроса, ПолучитьВсеФайлы);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

// Возвращает число файлов с неизвлеченным текстом
//
Процедура ПолучитьКоличествоВерсийСНеизвлеченнымТекстом(ЧислоВерсий) Экспорт
	
	ЧислоВерсий = 0;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ЧислоВерсий = ЧислоВерсий + РаботаСФайламиВызовСервера.ПолучитьКоличествоВерсийСНеизвлеченнымТекстом();
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ЧислоВерсий = ЧислоВерсий + ПрисоединенныеФайлы.ПолучитьКоличествоВерсийСНеизвлеченнымТекстом();
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

Процедура ПодсчитатьРазмерФайловНаТоме(СсылкаТома, РазмерФайлов) Экспорт
	
	РазмерФайлов = 0;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РазмерФайлов = РазмерФайлов + РаботаСФайламиВызовСервера.ПодсчитатьРазмерФайловНаТоме(СсылкаТома);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры
	
// Получает полный путь к файлу на диске
Функция ПолучитьИмяФайлаСПутемКДвоичнымДанным(ФайлСсылка) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если РаботаСФайламиСобытия.ЭтоЭлементРаботаСФайлами(ФайлСсылка) Тогда
		Возврат РаботаСФайламиВызовСервера.ПолучитьИмяФайлаСПутемКДвоичнымДанным(ФайлСсылка);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	Если ПрисоединенныеФайлыСобытия.ЭтоЭлементПрисоединенныеФайлы(ФайлСсылка) Тогда
		Возврат ПрисоединенныеФайлы.ПолучитьИмяФайлаСПутемКДвоичнымДанным(ФайлСсылка);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецФункции

// Записывает извлеченный текст
Процедура ЗаписатьИзвлеченныйТекст(ФайлОбъект) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если РаботаСФайламиСобытия.ЭтоЭлементРаботаСФайлами(ФайлОбъект) Тогда
		РаботаСФайламиВызовСервера.ЗаписатьИзвлеченныйТекст(ФайлОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	Если ПрисоединенныеФайлыСобытия.ЭтоЭлементПрисоединенныеФайлы(ФайлОбъект) Тогда
		ПрисоединенныеФайлы.ЗаписатьИзвлеченныйТекст(ФайлОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

// Возвращает навигационную ссылку на файл (на реквизит или во временное хранилище)
Функция ПолучитьНавигационнуюСсылкуФайла(ФайлСсылка, УникальныйИдентификатор) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если РаботаСФайламиСобытия.ЭтоЭлементРаботаСФайлами(ФайлСсылка) Тогда
		Возврат РаботаСФайламиВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(ФайлСсылка, УникальныйИдентификатор);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	Если ПрисоединенныеФайлыСобытия.ЭтоЭлементПрисоединенныеФайлы(ФайлСсылка) Тогда
		Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(ФайлСсылка, УникальныйИдентификатор).СсылкаНаДвоичныеДанныеФайла;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецФункции

// Возвращает в параметре КоличествоФайловВТомах количество файлов в томах.
//
Процедура ПолучитьКоличествоФайловВТомах(КоличествоФайловВТомах) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиВызовСервера.ПолучитьКоличествоФайловВТомах(КоличествоФайловВТомах);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлы.ПолучитьКоличествоФайловВТомах(КоличествоФайловВТомах);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

// Выполняет дополнительную обработку при отправке данных обмена.
//
Процедура ВыполнитьДополнительнуюОбработкуПриОтправкеДанных(ЭлементДанных) Экспорт
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлыСобытия.ВыполнитьДополнительнуюОбработкуПриОтправкеДанных(ЭлементДанных);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиСобытия.ВыполнитьДополнительнуюОбработкуПриОтправкеДанных(ЭлементДанных);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

// Выполняет дополнительную обработку при получении данных обмена.
//
Процедура ВыполнитьДополнительнуюОбработкуПриПолученииДанных(ЭлементДанных) Экспорт
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлыСобытия.ВыполнитьДополнительнуюОбработкуПриПолученииДанных(ЭлементДанных);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиСобытия.ВыполнитьДополнительнуюОбработкуПриПолученииДанных(ЭлементДанных);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

// Возвращает Истина в параметре ЕстьХранимыеФайлы, если есть хранимые файлы к объекту ВнешнийОбъект.
//
Процедура ОпределитьНаличиеХранимыхФайлов(ВнешнийОбъект, ЕстьХранимыеФайлы) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиВызовСервера.ОпределитьНаличиеХранимыхФайлов(ВнешнийОбъект, ЕстьХранимыеФайлы);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлы.ОпределитьНаличиеХранимыхФайлов(ВнешнийОбъект, ЕстьХранимыеФайлы);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
КонецПроцедуры

// Возвращает в параметре ХранимыеФайлы массив хранимых файлов к объекту ВнешнийОбъект.
//
Процедура ПолучитьХранимыеФайлы(ВнешнийОбъект, ХранимыеФайлы) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиВызовСервера.ПолучитьХранимыеФайлы(ВнешнийОбъект, ХранимыеФайлы);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлы.ПолучитьХранимыеФайлы(ВнешнийОбъект, ХранимыеФайлы);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
		
КонецПроцедуры

// Читает кодировку версии файла
//
// Параметры
// ВерсияСсылка - ссылка на версию файла
//
// Возвращаемое значение:
//   Строка кодировки
Процедура ПолучитьКодировкуВерсииФайла(ВерсияСсылка, Кодировка) Экспорт
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Кодировка = РаботаСФайламиВызовСервера.ПолучитьКодировкуВерсииФайла(ВерсияСсылка);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры
