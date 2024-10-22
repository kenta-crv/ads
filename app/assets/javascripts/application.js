// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require plugins/paragraph_format.min.js
//= require rails-ujs
//= require activestorage
//= require_tree .

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

document.addEventListener('DOMContentLoaded', function() {
    flatpickr(".flatpickr", {
      enableTime: false,
      dateFormat: "Y-m-d",
      minDate: "today",
    });
  });


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

    let pricePerNight = checkPeakSeason(checkInDate) || checkPeakSeason(checkOutDate) ? 70000 : 55000;
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

  checkInInput.addEventListener('change', updatePrice);
  checkOutInput.addEventListener('change', updatePrice);
});
