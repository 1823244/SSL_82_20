﻿// Сохраняет отредактированный файл в ИБ и снимает с него блокировку
Процедура ЗакончитьРедактирование(
	ПараметрКоманды, 
	ИдентификаторФормы, 
	Знач ХранитьВерсии = Неопределено,
	Знач РедактируетТекущийПользователь = Неопределено, 
	Знач Редактирует = Неопределено,
	Знач АвторТекущейВерсии = Неопределено,
	Знач Кодировка = Неопределено) Экспорт
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		МассивОбработанных = РаботаСФайламиКлиент.ЗакончитьРедактированиеПоСсылкам(
			ПараметрКоманды, 
			ИдентификаторФормы); 
			
		ОповеститьОбИзменении(Тип("СправочникСсылка.Файлы"));
		
		Для Каждого ФайлСсылка Из МассивОбработанных Цикл
			Оповестить("Запись_Файл", Новый Структура("Событие", "ЗаконченоРедактирование"), ФайлСсылка);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ФайлСсылка);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ВерсияСохранена"), ФайлСсылка);
		КонецЦикла;	
		
	Иначе	
		
		РедактированиеЗакончено = Ложь;
		
		РедактированиеЗакончено = РаботаСФайламиКлиент.ЗакончитьРедактирование(
			ПараметрКоманды, 
			ИдентификаторФормы,
			ХранитьВерсии,
			РедактируетТекущийПользователь,
			Редактирует,
			АвторТекущейВерсии,
			"", //ПереданныйПолныйПутьКФайлу
			Неопределено, //СоздатьНовуюВерсию
			Неопределено, //КомментарийКВерсии
			Истина, //ПоказыватьОповещение
			Ложь, //ПрименитьКоВсем
			Истина, //ОсвобождатьФайлы
			Кодировка); 
		
			Если РедактированиеЗакончено Тогда 
				
			Оповестить("Запись_Файл", Новый Структура("Событие", "ЗаконченоРедактирование"), ПараметрКоманды);
			
			ОповеститьОбИзменении(ПараметрКоманды);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ПараметрКоманды);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ВерсияСохранена"), ПараметрКоманды);
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

// Блокирует файл для редактирования и открывает его
Процедура Редактировать(ОбъектСсылка, УникальныйИдентификатор = Неопределено, РабочийКаталогВладельца = Неопределено) Экспорт
	
	Если ОбъектСсылка = Неопределено Тогда
		Возврат;
	КонецЕсли;	
		
	Если РаботаСФайламиКлиент.РедактироватьФайлПоСсылке(ОбъектСсылка, УникальныйИдентификатор, РабочийКаталогВладельца) Тогда
		ОповеститьОбИзменении(ОбъектСсылка);
		Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ОбъектСсылка);
		Оповестить("Запись_Файл", Новый Структура("Событие", "ФайлРедактировался"), ОбъектСсылка);
	КонецЕсли;	
	
КонецПроцедуры

// Выполняет блокировку файла или нескольких файлов
// ПараметрКоманды - либо ссылка на файл, либо массив ссылок на файлы
Процедура Занять(ПараметрКоманды, УникальныйИдентификатор = Неопределено) Экспорт
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		РаботаСФайламиКлиент.ЗанятьФайлыПоСсылкам(ПараметрКоманды);
		
		ОповеститьОбИзменении(Тип("СправочникСсылка.Файлы"));
		Для Каждого ФайлСсылка Из ПараметрКоманды Цикл
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ФайлСсылка);
		КонецЦикла;	
		
	Иначе	
		
		Если РаботаСФайламиКлиент.ЗанятьФайлПоСсылке(ПараметрКоманды, УникальныйИдентификатор) Тогда 
			ОповеститьОбИзменении(ПараметрКоманды);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ПараметрКоманды);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

// Освобождает занятый ранее файл
Процедура ОсвободитьФайл(
	ПараметрКоманды,
	Знач ХранитьВерсии = Неопределено,
	Знач РедактируетТекущийПользователь = Неопределено, 
	Знач Редактирует = Неопределено,
	УникальныйИдентификатор = Неопределено) Экспорт

	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		РаботаСФайламиКлиент.ОсвободитьФайлыПоСсылкам(ПараметрКоманды); 
		
		ОповеститьОбИзменении(Тип("СправочникСсылка.Файлы"));		
		Для Каждого ФайлСсылка Из ПараметрКоманды Цикл
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ФайлСсылка);
		КонецЦикла;	
			
	Иначе	
		
		Если РаботаСФайламиКлиент.ОсвободитьФайл(
			ПараметрКоманды, 
			ХранитьВерсии,
			РедактируетТекущийПользователь,
			Редактирует,
			УникальныйИдентификатор) Тогда
			
			ОповеститьОбИзменении(ПараметрКоманды);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ПараметрКоманды);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает файл для просмотра
Процедура Открыть(ДанныеФайла) Экспорт
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Событие", "ФайлОткрыт");
	Оповестить("ФайлОткрыт", ПараметрыОповещения, ДанныеФайла.Ссылка);
	
КонецПроцедуры

// Сохраняет файл в информационной базе, но не освобождает его
Процедура ОпубликоватьФайл(ПараметрКоманды, ИдентификаторФормы) Экспорт
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		РаботаСФайламиКлиент.ОпубликоватьФайлыПоСсылкам(ПараметрКоманды, ИдентификаторФормы);
		
		Для Каждого ФайлСсылка Из ПараметрКоманды Цикл
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ФайлСсылка);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ВерсияСохранена"), ФайлСсылка);
		КонецЦикла;	
			
	Иначе	
		
		Если РаботаСФайламиКлиент.ОпубликоватьФайл(ПараметрКоманды, ИдентификаторФормы) Тогда
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ПараметрКоманды);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ВерсияСохранена"), ПараметрКоманды);
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает каталог на локальном компьютере в котором размещен этот файл
Процедура ОткрытьКаталогФайла(ДанныеФайла) Экспорт
	
	РаботаСФайламиКлиент.КаталогФайла(ДанныеФайла);
	
КонецПроцедуры

// Сохраняет текущую версию файла в выбранный каталог на жестком или сетевом диске
Процедура СохранитьКак(ДанныеФайла, УникальныйИдентификатор = Неопределено) Экспорт
	
	РаботаСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);	
	
КонецПроцедуры

// Выбирает на  диске файл и создает из него новую версию
Процедура ОбновитьИзФайлаНаДиске(ДанныеФайла, ИдентификаторФормы) Экспорт
	
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	Если РасширениеПодключено Тогда
		
		Если РаботаСФайламиКлиент.ОбновитьИзФайлаНаДиске(ДанныеФайла, ИдентификаторФормы) Тогда	
			ОповеститьОбИзменении(ДанныеФайла.Ссылка);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ДанныеФайла.Ссылка);
			Оповестить("Запись_Файл", Новый Структура("Событие", "ВерсияСохранена"), ДанныеФайла.Ссылка);
		КонецЕсли;
	
	Иначе
		Предупреждение(НСтр("ru = 'Для выполнения данной операции вам нужно установить расширение работы с файлами.'"));
	КонецЕсли;
	
КонецПроцедуры

// Формирует электронную цифровую подпись
//
Функция СформироватьПодписьФайла(ДанныеФайла, ДанныеПодписи) Экспорт
	
	Если НЕ ДанныеФайла.Редактирует.Пустая() Тогда
		Предупреждение(ФайловыеФункцииКлиентСервер.СтрокаСообщенияОНедопустимостиПодписанияЗанятогоФайла());
		Возврат Ложь;
	КонецЕсли;
	
	Если ДанныеФайла.Зашифрован Тогда
		Предупреждение(ФайловыеФункцииКлиентСервер.СтрокаСообщенияОНедопустимостиПодписанияЗашифрованногоФайла());
		Возврат Ложь;
	КонецЕсли;
	
	ТолькоЛичные = Истина;
	МассивСтруктурСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(ТолькоЛичные);
	ПараметрыФормы = Новый Структура("МассивСтруктурСертификатов, ОбъектСсылка", МассивСтруктурСертификатов, ДанныеФайла.Ссылка);
	
	СтруктураПараметровПодписи = ОткрытьФормуМодально("ОбщаяФорма.УстановкаПодписиЭЦП", ПараметрыФормы);
	
	Если ТипЗнч(СтруктураПараметровПодписи) = Тип("Структура") Тогда
		
		СтруктураВозврата = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИДвоичныеДанные(ДанныеФайла.Ссылка);
		
		МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии();
		
		ДанныеПодписи = ЭлектроннаяЦифроваяПодписьКлиент.СформироватьДанныеПодписи(
			МенеджерКриптографии, ДанныеФайла.Ссылка, 
			СтруктураВозврата.ДвоичныеДанные, СтруктураПараметровПодписи);
			
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Зашифровать файл
//
Функция Зашифровать(ДанныеФайла,
					УникальныйИдентификатор,
					МассивДанныхДляЗанесенияВБазу,
					МассивОтпечатков) Экспорт
	
	Если ДанныеФайла.Зашифрован Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Файл ""%1"" уже зашифрован.'"), Строка(ДанныеФайла.Ссылка));
		Предупреждение(Текст);
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ДанныеФайла.Редактирует.Пустая() Тогда
		Предупреждение(НСтр("ru = 'Нельзя зашифровать занятый файл.'"));
		Возврат Ложь;
	КонецЕсли;
	
	МассивСтруктурСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Ложь);
	
	ОтпечатокЛичногоСертификатаДляШифрования = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ОтпечатокЛичногоСертификатаДляШифрования;
	
	// отпечаток сохраненный в ХранилищеНастроек мог устареть - сертификат могли уже удалить
	Если ОтпечатокЛичногоСертификатаДляШифрования <> Неопределено И НЕ ПустаяСтрока(ОтпечатокЛичногоСертификатаДляШифрования) Тогда
		
		Сертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(ОтпечатокЛичногоСертификатаДляШифрования, Истина); // ТолькоЛичные
		Если Сертификат = Неопределено Тогда		
			ОтпечатокЛичногоСертификатаДляШифрования = "";
		КонецЕсли;
		
	Иначе	
		
		МассивСтруктурЛичныхСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина); // ТолькоЛичные
		
		ПараметрыФормы = Новый Структура("МассивСтруктурСертификатов", МассивСтруктурЛичныхСертификатов);		
		СтруктураВозврата = ОткрытьФормуМодально("ОбщаяФорма.ВыборСертификата", ПараметрыФормы);
		Если ТипЗнч(СтруктураВозврата) = Тип("Структура") Тогда
			ОтпечатокЛичногоСертификатаДляШифрования = СтруктураВозврата.Отпечаток;
			ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения("ЭЦП", "ОтпечатокЛичногоСертификатаДляШифрования", ОтпечатокЛичногоСертификатаДляШифрования);
		Иначе
			Предупреждение(НСтр("ru = 'Не выбран персональный сертификат для шифрования.'"));
			Возврат Ложь;
		КонецЕсли;	
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("МассивСтруктурСертификатов, ФайлСсылка, ОтпечатокЛичногоСертификатаДляШифрования",
							МассивСтруктурСертификатов,
							ДанныеФайла.Ссылка,
							ОтпечатокЛичногоСертификатаДляШифрования);
	СтруктураВозврата = ОткрытьФормуМодально("ОбщаяФорма.ВыборСертификатовШифрования", ПараметрыФормы);
	
	Если ТипЗнч(СтруктураВозврата) = Тип("Массив") Тогда
		
		Возврат РаботаСФайламиКлиент.Зашифровать(ДанныеФайла.Ссылка,
												СтруктураВозврата,
												УникальныйИдентификатор,
												ДанныеФайла,
												МассивДанныхДляЗанесенияВБазу,
												МассивОтпечатков);
			
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Расшифровать файл
//
Функция Расшифровать(ДанныеФайла, УникальныйИдентификатор, 
	МассивДанныхДляЗанесенияВБазу) Экспорт
	
	Возврат РаботаСФайламиКлиент.Расшифровать(ДанныеФайла.Ссылка, УникальныйИдентификатор, 
		ДанныеФайла, МассивДанныхДляЗанесенияВБазу);
		
КонецФункции

// Добавить ЭЦП из файла
//
Функция ДобавитьЭЦПИзФайла(ДанныеФайла, УникальныйИдентификатор = Неопределено) Экспорт
	
	#Если НЕ ВебКлиент Тогда
	
		МассивФайловПодписей = ОткрытьФормуМодально("ОбщаяФорма.ДобавлениеПодписиИзФайла");
		
		Если ТипЗнч(МассивФайловПодписей) <> Тип("Массив") ИЛИ МассивФайловПодписей.Количество() = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
		
		МассивДанныхДляЗанесенияВБазу = ЭлектроннаяЦифроваяПодписьКлиент.СформироватьПодписиДляЗанесениюВБазу(ДанныеФайла.Ссылка, МассивФайловПодписей, УникальныйИдентификатор);
		
		Если МассивДанныхДляЗанесенияВБазу.Количество() > 0 Тогда
			РаботаСФайламиКлиент.ЗанестиИнформациюОПодписях(ДанныеФайла.Ссылка, ДанныеФайла.Владелец, МассивДанныхДляЗанесенияВБазу, УникальныйИдентификатор);
		КонецЕсли;
		
		Возврат Истина;
		
	#Иначе
		Предупреждение(НСтр("ru = 'В Веб-клиенте добавление ЭЦП из файла не поддерживается.'"));
		Возврат Ложь;
	#КонецЕсли
	
КонецФункции

// СохранитьКак вместе с ЭЦП
//
Процедура СохранитьВместеСЭЦП(ДанныеФайла, УникальныйИдентификатор) Экспорт
	
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	Если РасширениеПодключено Тогда
		
		Настройка = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП().ДействияПриСохраненииСЭЦП;
		
		Если Настройка = "Спрашивать" Тогда
			ПараметрыФормы = Новый Структура("Объект, УникальныйИдентификатор", ДанныеФайла.ТекущаяВерсия, УникальныйИдентификатор);
			МассивСтруктурПодписей = ОткрытьФормуМодально("ОбщаяФорма.ВыборПодписей", ПараметрыФормы);
		ИначеЕсли Настройка = "СохранятьВсеПодписи" Тогда
			МассивСтруктурПодписей = РаботаСФайламиВызовСервера.ПолучитьВсеПодписи(ДанныеФайла.Ссылка, УникальныйИдентификатор);
		КонецЕсли;
		
		Если ТипЗнч(МассивСтруктурПодписей) = Тип("Массив") И МассивСтруктурПодписей.Количество() > 0 Тогда
			
			ПолноеИмяФайла = РаботаСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
			
			Если ПолноеИмяФайла = "" Тогда
				Возврат; // пользователь нажал Отмена или это веб клиент без расширения
			КонецЕсли;
			
			ЭлектроннаяЦифроваяПодписьКлиент.СохранитьПодписи(ДанныеФайла.Ссылка, ПолноеИмяФайла, УникальныйИдентификатор, МассивСтруктурПодписей);
		КонецЕсли;
	
	Иначе
		Предупреждение(НСтр("ru = 'Для выполнения данной операции вам нужно установить расширение работы с файлами.'"));
	КонецЕсли;
	
КонецПроцедуры
