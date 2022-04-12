using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetStoneComponent : MonoBehaviour
{
    [SerializeField]
    private Animator referenceAnimator;
    [SerializeField]
    private string enableAnimationTrigger;
    [SerializeField]
    private string disableAnimationTrigger;
    private bool called = false;
    public bool IsCalled { get { return this.called; } }


    public void Call()
    {
        if (referenceAnimator != null)
            this.referenceAnimator.SetTrigger(enableAnimationTrigger);
        this.called = true;
        print("CALLED!");
    }
   
    public void UnCall()
    {
        if(referenceAnimator!=null)
            this.referenceAnimator.SetTrigger(disableAnimationTrigger);
        this.called = false;
        print("UNCALLED!");
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
       
    }
}
