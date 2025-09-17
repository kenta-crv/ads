// Manifest File Configuration
// require plugins/paragraph_format.min.js
//= require rails-ujs
//= require activestorage
//= require_tree .

// ナビゲーションの切り替え
$(function() {
  $('.navToggle').click(function() {
      $(this).toggleClass('active');

      if ($(this).hasClass('active')) {
          $('.globalMenuSp').addClass('active');
      } else {
          $('.globalMenuSp').removeClass('active');
      }
  });
});

// Flatpickr初期化
document.addEventListener('DOMContentLoaded', function() {
  const availableRanges = [
      { from: "2025-01-01", to: "2025-09-30" }
  ];

  flatpickr(".flatpickr", {
      enable: availableRanges.map(range => {
          return {
              from: range.from,
              to: range.to
          };
      }),
      dateFormat: "Y-m-d",
      minDate: "today",
      disableMobile: true
  });
});

// 料金計算と表示
document.addEventListener('DOMContentLoaded', function() {
  const checkInInput = document.querySelector('[name="check_in_date"]');
  const checkOutInput = document.querySelector('[name="check_out_date"]');
  const priceDisplayIn = document.querySelector('#price-display.check-in-price');
  const priceDisplayOut = document.querySelector('#price-display.check-out-price');

  const peakSeasons = [
      { start: new Date('2024-12-20'), end: new Date('2025-01-10') },
      { start: new Date('2025-01-25'), end: new Date('2025-02-10') },
      { start: new Date('2025-03-20'), end: new Date('2025-04-10') },
      { start: new Date('2025-04-28'), end: new Date('2025-05-10') },
      { start: new Date('2025-07-01'), end: new Date('2025-08-31') }
  ];

  function checkPeakSeason(date) {
      return peakSeasons.some(season => date >= season.start && date <= season.end);
  }

  function updatePrice() {
      const checkInDate = new Date(checkInInput.value);
      const checkOutDate = new Date(checkOutInput.value);

      let pricePerNight = checkPeakSeason(checkInDate) || checkPeakSeason(checkOutDate) ? 55000 : 39500;
      let numDays = (checkOutDate - checkInDate) / (1000 * 60 * 60 * 24);

      if (!isNaN(numDays) && numDays > 0) {
          let totalPrice = pricePerNight * numDays;
          priceDisplayIn.textContent = `1泊の料金: ¥${pricePerNight}`;
          priceDisplayOut.textContent = `合計金額: ¥${totalPrice}`;
      } else {
          priceDisplayIn.textContent = '';
          priceDisplayOut.textContent = '';
      }
  }

  if (checkInInput) checkInInput.addEventListener('change', updatePrice);
  if (checkOutInput) checkOutInput.addEventListener('change', updatePrice);
});

// SwiperとFancyboxの初期化
document.addEventListener("DOMContentLoaded", function () {
  const swiper = new Swiper('.swiper-container', {
      loop: true,
      autoplay: {
          delay: 3000,
      },
      pagination: {
          el: '.swiper-pagination',
          clickable: true,
      },
      navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev',
      },
  });

  Fancybox.bind("[data-fancybox='gallery']", {
      Image: {
          fit: "contain",
      },
  });
});

const swiper = new Swiper('.slider', {
  loop: true,
  autoplay: {
      delay: 3000,
  },
  pagination: {
      el: '.swiper-pagination',
      clickable: true,
  },
  breakpoints: {
      640: {
          slidesPerView: 1,
          spaceBetween: 10,
      },
      768: {
          slidesPerView: 2,
          spaceBetween: 20,
      },
      1024: {
          slidesPerView: 3,
          spaceBetween: 30,
      },
  },
});

// サーバーサイド料金計算（fetchリクエスト）
document.addEventListener('DOMContentLoaded', () => {
  const checkInField = document.querySelector("[name='check_in_date']");
  const checkOutField = document.querySelector("[name='check_out_date']");
  const priceDisplay = document.getElementById('price-display');

  const calculatePrice = () => {
      const checkInDate = checkInField.value;
      const checkOutDate = checkOutField.value;

      if (checkInDate && checkOutDate) {
          fetch(`/top/calculate_price?check_in_date=${checkInDate}&check_out_date=${checkOutDate}`)
              .then(response => response.json())
              .then(data => {
                  if (data.error) {
                      priceDisplay.textContent = data.error;
                  } else {
                      priceDisplay.textContent = `合計金額: ¥${data.total_price.toLocaleString()} (通常日${data.normal_days}日, ピーク${data.peak_days}日)`;
                  }
              })
              .catch(error => {
                  console.error('エラー:', error);
                  priceDisplay.textContent = "金額の計算中にエラーが発生しました。";
              });
      }
  };

  if (checkInField) checkInField.addEventListener('change', calculatePrice);
  if (checkOutField) checkOutField.addEventListener('change', calculatePrice);
});