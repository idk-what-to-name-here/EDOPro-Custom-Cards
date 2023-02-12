--Morioh
local s,id=GetID()
function s.initial_effect(c)
    --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Protection
	local ea=Effect.CreateEffect(c)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(ea)
	local eb=ea:Clone()
	eb:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(eb)
	local ec=ea:Clone()
	ec:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(ec)
	local ed=ea:Clone()
	ed:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(ed)
	local ee=ea:Clone()
	ee:SetType(EFFECT_TYPE_SINGLE)
	ee:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee:SetCode(EFFECT_CANNOT_REMOVE)
	ee:SetRange(LOCATION_FZONE)
	c:RegisterEffect(ee)
	--Summon a Jojo character
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)	
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.dircon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)	
end
s.listed_series={0x1010}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.CreateToken(tp,258639)
	if tc1:IsAbleToHand() then
		Duel.SendtoHand(tc1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc1)
		tc1:CompleteProcedure()
	    end
	local tc2=Duel.CreateToken(tp,258640)
	if tc2:IsAbleToHand() then
		Duel.SendtoHand(tc2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc2)
		tc2:CompleteProcedure()
	    end
	local tc3=Duel.CreateToken(tp,258636)
	if tc3:IsAbleToHand() then
		Duel.SendtoHand(tc3,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc3)
		tc3:CompleteProcedure()
	    end
	local tc3=Duel.CreateToken(tp,258634)
	if tc3:IsAbleToHand() then
		Duel.SendtoHand(tc3,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc3)
		tc3:CompleteProcedure()
	    end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function s.filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1010)
end
function s.dircon(e)
	return not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x4b),0,LOCATION_MZONE,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local dice1,dice2=Duel.TossDice(tp,2)
	local totaldice=dice1+dice2
      if totaldice<8 and totaldice~=2 then
	  local tc1=Duel.CreateToken(tp,258637)
	if tc1:IsCanBeSpecialSummoned(e,0,tp,false,false) then
       Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
	   end
    else
	local tc2=Duel.CreateToken(tp,99284890)
	if tc2:IsCanBeSpecialSummoned(e,0,tp,false,false) then
       Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
  end
end