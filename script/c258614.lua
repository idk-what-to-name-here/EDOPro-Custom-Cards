--Chimera Hydradrive Dragrid
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x577)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),5,5,s.lcheck)
	c:EnableReviveLimit()
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ctcon)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(s.condition)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.roll_dice=true
function s.lcheck(g,lc,sumtype,tp)
	return g:CheckDifferentPropertyBinary(Card.GetAttribute,lc,sumtype,tp)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x577,1)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x577,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x577,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,1,tp)
end
function s.dragheadwindy_filter(c,e,tp)
	return c:IsCode(258617) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.dragheadlightning_filter(c,e,tp)
	return c:IsCode(258616) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.dragheadaqua_filter(c,e,tp)
	return c:IsCode(258613) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.dragheadflame_filter(c,e,tp)
	return c:IsCode(258612) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.dragheadearth_filter(c,e,tp)
    return c:IsCode(258618) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
      local dice=Duel.TossDice(tp,1)
      if dice==1 and Duel.IsExistingMatchingCard(s.dragheadearth_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.dragheadearth_filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
	    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end 
     elseif dice==2 and Duel.IsExistingMatchingCard(s.dragheadaqua_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.dragheadaqua_filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
	    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end 
	 elseif dice==3 and Duel.IsExistingMatchingCard(s.dragheadflame_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.dragheadflame_filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
	    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
	 elseif dice==4 and Duel.IsExistingMatchingCard(s.dragheadwindy_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.dragheadwindy_filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
	    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end 
     elseif dice==5 and Duel.IsExistingMatchingCard(s.dragheadlightning_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.dragheadlightning_filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
	    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end 	
   end
end