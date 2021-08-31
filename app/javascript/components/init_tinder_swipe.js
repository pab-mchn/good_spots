import Rails from '@rails/ujs'
import Hammer from 'hammerjs'

const initTinderSwipe = () => {
    const tinderCards = document.querySelectorAll(".swipe-card-stack")
    tinderCards.forEach((card) => {
        const tinderCard = new Hammer(card)
        tinderCard.on('pan', (event) => {
            const xMulti = event.deltaX * 0.03;
            const yMulti = event.deltaY / 80;
            const rotate = xMulti * yMulti;
            card.style.transform = 'translate(' + event.deltaX + 'px, ' + event.deltaY + 'px) rotate(' + rotate + 'deg)';
        })
        tinderCard.on('panend', (event) => {
            const moveOutWidth = document.body.clientWidth
            const keep = Math.abs(event.deltaX) < 80 || Math.abs(event.velocityX) < 0.3

            if (keep) {
                card.style.transform = ''
            } else {
                const endX = Math.max(Math.abs(event.velocityX) * moveOutWidth, moveOutWidth);
                const toX = event.deltaX > 0 ? endX : -endX;
                const endY = Math.abs(event.velocityY) * moveOutWidth;
                const toY = event.deltaY > 0 ? endY : -endY;
                const xMulti = event.deltaX * 0.03;
                const yMulti = event.deltaY / 80;
                const rotate = xMulti * yMulti;
                const liked = event.deltaX > 0 
                const placeId = card.dataset.placeId
                const url = ` /places/${placeId}/viewings`
                Rails.ajax({
                    url: url,
                    type: "post",
                    data: `viewing[liked]=${liked}`
                })
                event.target.style.transform = 'translate(' + toX + 'px, ' + (toY + event.deltaY) + 'px) rotate(' + rotate + 'deg)';
            }
        })
    })
}

export { initTinderSwipe }