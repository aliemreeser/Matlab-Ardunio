
#define trigPin 13 //Sensörün trigger bacağının bağlı oldugu pin trigPin sabiti olarak tanımlandı.
#define echoPin 12 //Sensörün echo bacağının bağlı oldugu pin echoPin sabiti olarak tanımlandı.



void setup() {
  Serial.begin (9600);      // Seri haberleşme hızı 9600 olarak ayarlanıyor (baud rate 1 saniyede gönderilen bit sayısı)
  pinMode(trigPin, OUTPUT); // Sensörün Trigger bacağına gerilim uygulayabilmemiz için OUTPUT yapıyoruz.
  pinMode(echoPin, INPUT);  // Sensörün Echo bacağındaki gerilimi okuyabilmemiz için INPUT yapıyoruz.
  
}

void loop() {
  long sure;
  long mesafe;
                                                                       /* Başlangıçta LOW durumda olan trigger bacağına gerilim uygulayıp ardından gerilimi keserek bir ses dalgası
                                                                   oluşturmuş oluyoruz. Bu işlem arasında 2 mikro saniye beklenmenin sebebi HC-SR04'ün en az 10 mikro saniyelik 
                                                                       dalgalar ile çalışmasıdır. */  
  digitalWrite(trigPin, LOW);  
  delayMicroseconds(2); 
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);   
  digitalWrite(trigPin, LOW);
                                                                    // Dalga üretildikten sonra geri yansıyıp Echo bacağının HIGH duruma geçireceği süreyi pulseIn fonksiyonu ile kaydediyoruz.
  sure = pulseIn(echoPin, HIGH);  //Mikrosaniye
  
                                                             // Aşağıda yapılan süre-mesafe dönüşüm işlemleri sunumda açıklanmıştır.
  mesafe = (sure*0.0173);
  
  
  
  
  Serial.print(mesafe);
    Serial.println(" cm");
    
                                    
  delay(100);                      //100 milisaniye=0.1sn
} 
