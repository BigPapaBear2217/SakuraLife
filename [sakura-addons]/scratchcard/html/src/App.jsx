import React, { useEffect, useState } from "react";
import ScratchCard from "react-scratchcard";
import axios from "axios";
import { Animated } from "react-animated-css";
import { post } from "jquery";

export default function App() {
  const [display, setDisplay] = useState(false);
  const [finished, setFinished] = useState(false);
  const [items, setItems] = useState([]);
  const [numbers, setNumbers] = useState([]);
  const [prize, setPrize] = useState(0);
  const [currency, setCurrency] = useState("$");

  useEffect(() => {
    window.addEventListener("message", (e) => {
      var data = e.data;
      switch (data.action) {
        case "openScratchCard":
          setFinished(false);
          setItems(data.items);
          setCurrency(data.currency);
          setPrize(data.prizes[Math.floor(Math.random() * data.prizes.length)]);
          generateNumbers(e.data.items.length);
          setDisplay(true);
          break;
        case "closeScratchCard":
          setDisplay(false);
          break;
        default:
          break;
      }
    });
  }, []);

  document.onkeydown = function (evt) {
    evt = evt || window.event;
    if (evt.key == "Escape") {
      close();
    }
  };

  const close = () => {
    post("https://scratchcard/close");
    setDisplay(false);
  };

  const generateNumbers = (itemLength) => {
    var nums = [];

    for (let i = 0; i < 9; i++) {
      nums[i] = Math.floor(Math.random() * itemLength).toFixed(0);
    }

    setNumbers(nums);
  };

  const CheckForWin = () => {
    var nums = {};
    var winner = false;

    for (let i = 0; i < numbers.length; i++) {
      const num = numbers[i];
      if (nums[num]) {
        nums[num] += 1;
      } else {
        nums[num] = 1;
      }
    }

    for (let num in nums) {
      if (nums[num] >= 3) {
        winner = true;
      }
    }

    return winner;
  };

  const settings = {
    width: 302,
    height: 183,
    image: "./assets/images/area.png",
    finishPercent: 85,
    onComplete: () => {
      setFinished(true);
      var winner = CheckForWin();

      if (winner) {
        post(
          "https://scratchcard/wonScratchCard",
          JSON.stringify({ prize: prize })
        );
      } else {
        post("https://scratchcard/lostScratchCard");
      }
    },
  };

  return (
    display && (
      <Animated
        animationIn="rotateInUpLeft"
        animationInDuration={750}
        isVisible={display}
      >
        <div className="card">
          <div id="closeBtn" hidden={!finished} onClick={close}>
            X
          </div>
          <div id="area">
            <ScratchCard {...settings}>
              <div className="wrapper">
                <div id="grid">
                  <div className="box">{items[numbers[0]]}</div>
                  <div className="box">{items[numbers[1]]}</div>
                  <div className="box">{items[numbers[2]]}</div>
                  <div className="box">{items[numbers[3]]}</div>
                  <div className="box">{items[numbers[4]]}</div>
                  <div className="box">{items[numbers[5]]}</div>
                  <div className="box">{items[numbers[6]]}</div>
                  <div className="box">{items[numbers[7]]}</div>
                  <div className="box">{items[numbers[8]]}</div>
                </div>
                <div id="prize">
                  <span className="blue">{currency}</span>
                  {numberWithCommas(prize)}
                </div>
              </div>
            </ScratchCard>
          </div>
        </div>
      </Animated>
    )
  );
}

function numberWithCommas(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
