﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отказ = Ложь;
	
	АдресВременногоХранилища = "";
	
	ПолучитьНастройкиОбменаДаннымиДляВторойИнформационнойБазыНаСервере(Отказ, АдресВременногоХранилища, ПараметрКоманды);
	
	Если Отказ Тогда
		
		Предупреждение(НСтр("ru = 'Возникли ошибки при получении настроек обмена данными.'"));
		
	Иначе
		
		ПолучитьФайл(АдресВременногоХранилища, НСтр("ru = 'Настройки обмена данными.xml'"), Истина);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПолучитьНастройкиОбменаДаннымиДляВторойИнформационнойБазыНаСервере(Отказ, АдресВременногоХранилища, УзелИнформационнойБазы)
	
	ПомощникСозданияОбменаДанными = Обработки.ПомощникСозданияОбменаДанными.Создать();
	ПомощникСозданияОбменаДанными.Инициализация(УзелИнформационнойБазы);
	ПомощникСозданияОбменаДанными.ВыполнитьВыгрузкуПараметровМастераВоВременноеХранилище(Отказ, АдресВременногоХранилища);
	
КонецПроцедуры
